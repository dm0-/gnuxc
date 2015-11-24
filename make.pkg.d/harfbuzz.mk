harfbuzz                := harfbuzz-1.1.1
harfbuzz_url            := http://www.freedesktop.org/software/harfbuzz/release/$(harfbuzz).tar.bz2

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--with-cairo \
		--with-freetype \
		--with-glib \
		--with-gobject \
		--with-icu \
		\
		--without-coretext \
		--without-graphite2 \
		--without-uniscribe

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,cairo freetype glib icu4c)
	$(MAKE) -C $(builddir) install
