freetype                := freetype-2.5.5
freetype_url            := http://download.savannah.gnu.org/releases/freetype/$(freetype).tar.bz2

configure-freetype-rule:
	cd $(freetype) && ./$(configure) \
		--with-bzip2 \
		--with-old-mac-fonts \
		--with-png \
		--with-zlib

build-freetype-rule:
	$(MAKE) -C $(freetype) all

install-freetype-rule: $(call installed,bzip2 libpng) # harfbuzz
	$(MAKE) -C $(freetype) install
