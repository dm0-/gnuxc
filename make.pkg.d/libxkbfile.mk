libxkbfile              := libxkbfile-1.0.9
libxkbfile_sha1         := d708d3415212febbc67d4d996d02d7e3218e13ad
libxkbfile_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libxkbfile).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libX11)
	$(MAKE) -C $(builddir) install
