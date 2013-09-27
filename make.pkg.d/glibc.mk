glibc                   := glibc-2.17.90-b8b176
glibc_branch            := tschwinge/Roger_Whittaker
glibc_snap              := b8b1766379d47341b781e2dd77a039cd8defc381
glibc_url               := git://git.sv.gnu.org/hurd/glibc.git

prepare-glibc-rule:
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-fix-documentation.patch
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-provide-hurd-api.patch
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-create-gnumach-header.patch

configure-glibc-rule: CFLAGS := $(CFLAGS:-O2=-O3)
configure-glibc-rule: CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
configure-glibc-rule: CFLAGS := $(CFLAGS:-fexceptions=-fasynchronous-unwind-tables)
configure-glibc-rule: CFLAGS := $(CFLAGS:-fstack-protector=)
configure-glibc-rule:
	$(MKDIR) $(glibc)/build && cd $(glibc)/build && ../$(configure) \
		--disable-multi-arch \
		--enable-all-warnings \
		--enable-obsolete-rpc \
		--enable-stackguard-randomization \
		BASH_SHELL='$(BASH)'

build-glibc-rule:
	$(MAKE) -C $(glibc)/build all \
		install_root=.

install-glibc-rule: $(call installed,hurd)
	$(MAKE) -C $(glibc)/build install
	$(RM) $(DESTDIR)/usr/include/bits/pthreadtypes.h
	$(SYMLINK) ld.so.1 $(DESTDIR)/lib/ld.so
	$(INSTALL) -dm 755 $(DESTDIR)/usr/lib/locale
