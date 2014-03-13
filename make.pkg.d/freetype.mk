freetype                := freetype-2.5.3
freetype_url            := http://download.savannah.gnu.org/releases/freetype/$(freetype).tar.bz2

configure-freetype-rule:
	cd $(freetype) && ./$(configure) \
		--with-bzip2 \
		--with-old-mac-fonts \
		--with-png \
		--with-zlib \
		LIBPNG_CFLAGS="`$(LIBPNG_CONFIG) --cflags`" \
		LIBPNG_LDFLAGS="`$(LIBPNG_CONFIG) --ldflags`"

build-freetype-rule:
	$(MAKE) -C $(freetype) all

install-freetype-rule: $(call installed,bzip2 libpng) # harfbuzz
	$(MAKE) -C $(freetype) install
