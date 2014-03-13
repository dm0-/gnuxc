glibc                   := glibc-2.17.90-bdb7a1
glibc_branch            := tschwinge/Roger_Whittaker
glibc_snap              := bdb7a18d78b04ac3ef7a2d905485500f13bb69fb
glibc_url               := git://git.sv.gnu.org/hurd/glibc.git

$(glibc)/libpthread: $(call prepared,libpthread) | $(glibc)
	$(COPY) --archive $(libpthread) $(glibc)/libpthread

prepare-glibc-rule:
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-fix-documentation.patch
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-provide-hurd-api.patch
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-create-gnumach-header.patch
	$(PATCH) -d $(glibc) -p1 < $(patchdir)/$(glibc)-pthread-posix.patch

configure-glibc-rule: CFLAGS := $(CFLAGS:-O2=-O3)
configure-glibc-rule: CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
configure-glibc-rule: CFLAGS := $(CFLAGS:-fexceptions=-fasynchronous-unwind-tables)
configure-glibc-rule: CFLAGS := $(CFLAGS:-fstack-protector=)
configure-glibc-rule: | $(glibc)/libpthread
	$(MKDIR) $(glibc)/build && cd $(glibc)/build && ../$(configure) \
		--disable-multi-arch \
		--enable-all-warnings \
		--enable-obsolete-rpc \
		--enable-stackguard-randomization \
		BASH_SHELL='$(BASH)' \
		\
		--disable-nscd

build-glibc-rule:
	$(MAKE) -C $(glibc)/build all \
		install_root=.

install-glibc-rule: $(call installed,hurd)
	$(MAKE) -C $(glibc)/build install
	$(SYMLINK) ld.so.1 $(DESTDIR)/lib/ld.so
	$(INSTALL) -dm 755 $(DESTDIR)/usr/lib/locale
