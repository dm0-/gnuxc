font-misc-misc          := font-misc-misc-1.1.2
font-misc-misc_sha1     := c6d28c56880807963175cbbd682fb6f75a35f77d
font-misc-misc_url      := http://xorg.freedesktop.org/releases/individual/font/$(font-misc-misc).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-all-encodings \
		--enable-strict-compilation \
		\
		--without-compression # Compression makes mkfontdir miss the fonts.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,font-util)
	$(MAKE) -C $(builddir) install
