mkfontscale             := mkfontscale-1.1.2
mkfontscale_sha1        := da32fe297732355eea71d4a94ed003be93d1eae7
mkfontscale_url         := http://xorg.freedesktop.org/releases/individual/app/$(mkfontscale).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-bzip2

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,freetype libfontenc xproto)
	$(MAKE) -C $(builddir) install
