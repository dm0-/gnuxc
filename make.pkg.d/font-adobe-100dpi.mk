font-adobe-100dpi       := font-adobe-100dpi-1.0.3
font-adobe-100dpi_url   := http://xorg.freedesktop.org/releases/individual/font/$(font-adobe-100dpi).tar.bz2

configure-font-adobe-100dpi-rule:
# Disable compression or mkfontdir will ignore the fonts.
	cd $(font-adobe-100dpi) && ./$(configure) \
		--disable-silent-rules \
		--enable-all-encodings \
		--enable-strict-compilation \
		\
		--without-compression

build-font-adobe-100dpi-rule:
	$(MAKE) -C $(font-adobe-100dpi) all

install-font-adobe-100dpi-rule: $(call installed,font-util)
	$(MAKE) -C $(font-adobe-100dpi) install
