libXrender              := libXrender-0.9.9
libXrender_sha1         := 31bf63dfb4fcb82a6db73abe98df87cb50c17176
libXrender_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libXrender).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libX11 renderproto)
	$(MAKE) -C $(builddir) install
