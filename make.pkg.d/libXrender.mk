libXrender              := libXrender-0.9.10
libXrender_sha1         := d55106de9260c2377c19d271d9b677744a6c7e81
libXrender_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libXrender).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libX11 renderproto)
	$(MAKE) -C $(builddir) install
