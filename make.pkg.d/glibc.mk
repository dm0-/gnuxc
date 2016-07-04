glibc                   := glibc-2.19-2032cc
glibc_branch            := tschwinge/Roger_Whittaker
glibc_sha1              := 2032cc261fc6434899a689ddec1b9230bcc774ac
glibc_url               := git://git.sv.gnu.org/hurd/glibc.git

glibc-libpthread        := libpthread-0.3-610622
glibc-libpthread_branch := master
glibc-libpthread_sha1   := 6106225fdc09f013ec4f7b1d7ec82780061c8a14
glibc-libpthread_url    := git://git.sv.gnu.org/hurd/libpthread.git

$(builddir)/libpthread: | $$(@D)
	$(GIT) clone --branch=$(glibc-libpthread_branch) -n $(glibc-libpthread_url) $@
	$(GIT) -C $@ reset --hard $(glibc-libpthread_sha1)
$(downloaded): | $(builddir)/libpthread

$(prepare-rule):
# Avoid race conditions regenerating this with an incompatible bison version.
	$(TOUCH) $(builddir)/intl/plural.c

$(configure-rule): CFLAGS := $(CFLAGS:-O2=-O3)
$(configure-rule): CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
$(configure-rule): CFLAGS := $(CFLAGS:-fexceptions%=)
$(configure-rule): CFLAGS := $(CFLAGS:-fstack-protector%=-fasynchronous-unwind-tables)
$(configure-rule):
	$(MKDIR) $(builddir)/build && cd $(builddir)/build && ../$(configure) \
		--disable-multi-arch \
		--disable-pt_chown \
		--enable-all-warnings \
		--enable-lock-elision \
		--enable-obsolete-rpc \
		--enable-stackguard-randomization \
		--without-selinux \
		BASH_SHELL='$(BASH)' \
		\
		--disable-nscd

$(build-rule):
# Force libpthread to build before librt.
	$(MAKE) -C $(builddir)/build mach/subdir_lib
	$(MAKE) -C $(builddir)/build hurd/subdir_lib
	$(MAKE) -C $(builddir)/build libpthread/subdir_lib
# Do the real build.
	$(MAKE) -C $(builddir)/build all info \
		CFLAGS-clock_gettime.c='-DSYSDEP_GETTIME="case CLOCK_MONOTONIC:"'
# This target seems to break parallel builds when given in the above command.
#	$(MAKE) -C $(builddir)/build info

$(install-rule): $$(call installed,hurd)
	$(MAKE) -C $(builddir)/build install
	$(SYMLINK) ld.so.1 $(DESTDIR)/lib/ld.so
	$(INSTALL) -dm 755 $(DESTDIR)/usr/lib/locale
