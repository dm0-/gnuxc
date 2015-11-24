mkfontdir               := mkfontdir-1.0.7
mkfontdir_url           := http://xorg.freedesktop.org/releases/individual/app/$(mkfontdir).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mkfontscale)
	$(MAKE) -C $(builddir) install
