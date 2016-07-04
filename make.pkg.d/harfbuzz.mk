harfbuzz                := harfbuzz-1.2.7
harfbuzz_sha1           := d8a1ee20de9e792e17c11b2c2c14ccc643aaeda1
harfbuzz_url            := http://www.freedesktop.org/software/harfbuzz/release/$(harfbuzz).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
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
