bdftopcf                := bdftopcf-1.0.5
bdftopcf_url            := http://xorg.freedesktop.org/releases/individual/app/$(bdftopcf).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXfont)
	$(MAKE) -C $(builddir) install
