font-adobe-100dpi       := font-adobe-100dpi-1.0.3
font-adobe-100dpi_url   := http://xorg.freedesktop.org/releases/individual/font/$(font-adobe-100dpi).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-all-encodings \
		--enable-strict-compilation \
		\
		--without-compression # Compression makes mkfontdir miss the fonts.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,font-util)
	$(MAKE) -C $(builddir) install
