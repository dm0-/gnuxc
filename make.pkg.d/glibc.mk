glibc                   := glibc-2.23-1d9e15
glibc_branch            := tschwinge/Roger_Whittaker
glibc_sha1              := 1d9e154ebefa4525484c3fab2e0941c3bd55e41b
glibc_url               := git://git.sv.gnu.org/hurd/glibc.git

glibc-libpthread        := libpthread-0.3-8f03a3
glibc-libpthread_branch := master
glibc-libpthread_sha1   := 8f03a364f803ad878ea3ab226fd2955ed4565495
glibc-libpthread_url    := git://git.sv.gnu.org/hurd/libpthread.git

$(eval $(call verify-download,fix-binutils-2.29.patch,http://sourceware.org/git/gitweb.cgi?p=glibc.git;a=blobdiff_plain;f=misc/regexp.c;hb=388b4f1a02f3a801965028bbfcd48d905638b797;hpb=bfff8b1becd7d01c074177df7196ab327cd8c844,10f5f65f14bb46ef3da326211aef13246db9466c))

$(builddir)/libpthread: | $$(@D)
	$(GIT) clone --branch=$(glibc-libpthread_branch) -n $(glibc-libpthread_url) $@
	$(GIT) -C $@ reset --hard $(glibc-libpthread_sha1)
$(downloaded): | $(builddir)/libpthread

$(prepare-rule):
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,fix-binutils-2.29.patch)
# Make sure this header can be located.
	$(EDIT) 's/<fork.h>/"fork.h"/' $(builddir)/libpthread/sysdeps/generic/pt-atfork.c
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
	$(INSTALL) -dm 0755 $(DESTDIR)/usr/lib/locale
