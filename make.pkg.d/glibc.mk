glibc                   := glibc-2.19-0c5c4d
glibc_branch            := tschwinge/Roger_Whittaker
glibc_snap              := 0c5c4d150f7447df4936acc5320472194b9dafae
glibc_url               := git://git.sv.gnu.org/hurd/glibc.git

glibc-libpthread        := libpthread-0.3-37d6d0
glibc-libpthread_branch := master
glibc-libpthread_snap   := 37d6d0fd80143a25b0d1f2a875e2cce6504d9567
glibc-libpthread_url    := git://git.sv.gnu.org/hurd/libpthread.git

$(call prepare-rule,libpthread): | $$(@D)
	$(GIT) clone -n $(glibc-libpthread_url) $(builddir)/libpthread
	$(GIT) -C $(builddir)/libpthread reset --hard $(glibc-libpthread_snap)
$(prepare-rule): $(call prepared,libpthread)

$(configure-rule): CFLAGS := $(CFLAGS:-O2=-O3)
$(configure-rule): CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
$(configure-rule): CFLAGS := $(CFLAGS:-fexceptions%=)
$(configure-rule): CFLAGS := $(CFLAGS:-fstack-protector%=-fasynchronous-unwind-tables)
$(configure-rule):
	$(MKDIR) $(builddir)/build && cd $(builddir)/build && ../$(configure) \
		--disable-multi-arch \
		--disable-pt_chown \
		--enable-all-warnings \
		--enable-obsolete-rpc \
		--enable-stackguard-randomization \
		BASH_SHELL='$(BASH)' \
		\
		--disable-nscd

$(build-rule):
	$(MAKE) -C $(builddir)/build all \
		CFLAGS-clock_gettime.c='-DSYSDEP_GETTIME="case CLOCK_MONOTONIC:"'
# This target seems to break parallel builds when given in the above command.
	$(MAKE) -C $(builddir)/build info

$(install-rule): $$(call installed,hurd)
	$(MAKE) -C $(builddir)/build install
	$(SYMLINK) ld.so.1 $(DESTDIR)/lib/ld.so
	$(INSTALL) -dm 755 $(DESTDIR)/usr/lib/locale
