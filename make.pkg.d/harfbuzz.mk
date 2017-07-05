harfbuzz                := harfbuzz-1.4.6
harfbuzz_sha1           := a296d9f7a82d5db1984d3b6efc4186c5dbcd7947
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
