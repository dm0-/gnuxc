e2fsprogs               := e2fsprogs-1.42.8
e2fsprogs_url           := http://prdownloads.sourceforge.net/e2fsprogs/$(e2fsprogs).tar.gz

prepare-e2fsprogs-rule:
	$(PATCH) -d $(e2fsprogs) -p1 < $(patchdir)/$(e2fsprogs)-add-pkgconfigdir.patch

configure-e2fsprogs-rule:
	cd $(e2fsprogs) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--enable-blkid-debug \
		--enable-compression \
		--enable-elf-shlibs \
		--enable-fsck \
		--enable-htree \
		--enable-quota \
		--enable-verbose-makecmds \
		--without-included-gettext

build-e2fsprogs-rule:
	$(MAKE) -C $(e2fsprogs) all

install-e2fsprogs-rule: $(call installed,libpthread)
	$(MAKE) -C $(e2fsprogs) install install-libs \
		pkgconfigdir=/usr/lib/pkgconfig
