freetype                := freetype-2.8
freetype_sha1           := 42c6b1f733fe13a3eba135f5025b22cb68450f91
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
