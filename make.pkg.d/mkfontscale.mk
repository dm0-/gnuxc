mkfontscale             := mkfontscale-1.1.2
mkfontscale_key         := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
mkfontscale_url         := http://xorg.freedesktop.org/releases/individual/app/$(mkfontscale).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-bzip2

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,freetype libfontenc xproto)
	$(MAKE) -C $(builddir) install
