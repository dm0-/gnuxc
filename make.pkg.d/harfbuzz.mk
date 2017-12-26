harfbuzz                := harfbuzz-1.7.4
harfbuzz_sha1           := acaca9dd723516a06c7a237c9a6894101f736993
harfbuzz_url            := http://www.freedesktop.org/software/harfbuzz/release/$(harfbuzz).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-static \
		--with-cairo \
		--with-fontconfig \
		--with-freetype \
		--with-glib \
		--with-gobject \
		--with-icu \
		\
		--without-coretext \
		--without-directwrite \
		--without-graphite2 \
		--without-uniscribe

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,cairo freetype glib icu4c)
	$(MAKE) -C $(builddir) install
