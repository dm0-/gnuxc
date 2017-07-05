texinfo                 := texinfo-6.4
texinfo_sha1            := 0812ffd078fc1f3b7600d43eec25ba1bddd4d4bd
texinfo_url             := http://ftpmirror.gnu.org/texinfo/$(texinfo).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-perl-api-texi-build \
		--enable-threads=posix \
		--with-external-libintl-perl \
		--with-external-Text-Unidecode \
		--with-external-Unicode-EastAsianWidth \
		--without-included-regex \
		\
		--disable-perl-xs # This only gets complied for the build system.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses zlib)
	$(MAKE) -C $(builddir) install
