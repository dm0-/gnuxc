mkfontdir               := mkfontdir-1.0.7
mkfontdir_url           := http://xorg.freedesktop.org/releases/individual/app/$(mkfontdir).tar.bz2

configure-mkfontdir-rule:
	cd $(mkfontdir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

build-mkfontdir-rule:
	$(MAKE) -C $(mkfontdir) all

install-mkfontdir-rule: $(call installed,mkfontscale)
	$(MAKE) -C $(mkfontdir) install
