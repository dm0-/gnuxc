font-adobe-100dpi       := font-adobe-100dpi-1.0.3
font-adobe-100dpi_sha1  := 53311cbd604f18bd9570727105a4222473d363e3
font-adobe-100dpi_url   := http://xorg.freedesktop.org/releases/individual/font/$(font-adobe-100dpi).tar.bz2

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
	$(INSTALL) -Dpm 0644 $(call addon-file,fonts.alias) $(DESTDIR)/usr/share/X11/fonts/100dpi/fonts.alias

# Provide a default font named "variable" (for NetHack) as chosen in Fedora.
$(call addon-file,fonts.alias): | $$(@D)
	$(ECHO) 'variable     -*-helvetica-bold-r-normal-*-*-120-*-*-*-*-iso8859-1' > $@
$(prepared): $(call addon-file,fonts.alias)
