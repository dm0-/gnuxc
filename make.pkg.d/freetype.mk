freetype                := freetype-2.6.1
freetype_url            := http://download.savannah.gnu.org/releases/freetype/$(freetype).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--with-bzip2 \
		--with-old-mac-fonts \
		--with-png \
		--with-zlib

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bzip2 libpng) # harfbuzz
	$(MAKE) -C $(builddir) install
