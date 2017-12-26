freetype                := freetype-2.8.1
freetype_key            := 58E0C111E39F5408C5D3EC76C1A60EACE707FDA5
freetype_url            := http://download.savannah.gnu.org/releases/freetype/$(freetype).tar.bz2

ifeq ($(host),$(build))
export FREETYPE_CONFIG = /usr/bin/freetype-config
else
export FREETYPE_CONFIG = /usr/bin/$(host)-freetype-config
endif

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
