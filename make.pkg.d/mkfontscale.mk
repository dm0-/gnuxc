mkfontscale             := mkfontscale-1.1.1
mkfontscale_url         := http://xorg.freedesktop.org/releases/individual/app/$(mkfontscale).tar.bz2

configure-mkfontscale-rule:
	cd $(mkfontscale) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-bzip2

build-mkfontscale-rule:
	$(MAKE) -C $(mkfontscale) all

install-mkfontscale-rule: $(call installed,freetype libfontenc xproto)
	$(MAKE) -C $(mkfontscale) install
