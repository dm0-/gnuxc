texinfo                 := texinfo-6.5
texinfo_key             := EAF669B31E31E1DECBD11513DDBC579DAB37FBA9
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
