glibc                   := glibc-2.23-8be94e
glibc_branch            := tschwinge/Roger_Whittaker
glibc_sha1              := 8be94e33d413e8c9685270b804c899f85389927a
glibc_url               := git://git.sv.gnu.org/hurd/glibc.git

glibc-libpthread        := libpthread-0.3-44873d
glibc-libpthread_branch := master
glibc-libpthread_sha1   := 44873df420d128972644ef3901c7d917ca3b7dd7
glibc-libpthread_url    := git://git.sv.gnu.org/hurd/libpthread.git

$(builddir)/libpthread: | $$(@D)
	$(GIT) clone --branch=$(glibc-libpthread_branch) -n $(glibc-libpthread_url) $@
	$(GIT) -C $@ reset --hard $(glibc-libpthread_sha1)
$(downloaded): | $(builddir)/libpthread

$(prepare-rule):
# Avoid race conditions regenerating this with an incompatible bison version.
	$(TOUCH) $(builddir)/intl/plural.c
# This static library does not exist.
	$(EDIT) 's/ [^ ]*mvec_nonshared[^ ]* / /g' $(builddir)/math/Makefile

$(configure-rule): CFLAGS := $(CFLAGS:-O2=-O3)
$(configure-rule): CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
$(configure-rule): CFLAGS := $(CFLAGS:-fexceptions%=)
$(configure-rule): CFLAGS := $(CFLAGS:-fstack-protector%=-fasynchronous-unwind-tables)
$(configure-rule):
	$(MKDIR) $(builddir)/build && cd $(builddir)/build && ../$(configure) \
		--disable-multi-arch \
		--disable-pt_chown \
		--disable-werror \
		--enable-all-warnings \
		--enable-lock-elision \
		--enable-mathvec \
		--enable-obsolete-rpc \
		--enable-stackguard-randomization \
		--enable-timezone-tools \
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

$(install-rule): $$(call installed,hurd)
	$(MAKE) -C $(builddir)/build install
	$(SYMLINK) ld.so.1 $(DESTDIR)/lib/ld.so
	$(INSTALL) -dm 755 $(DESTDIR)/usr/lib/locale
