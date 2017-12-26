libxkbfile              := libxkbfile-1.0.9
libxkbfile_key          := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
libxkbfile_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libxkbfile).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libX11)
	$(MAKE) -C $(builddir) install
