xrandr                  := xrandr-1.4.3
xrandr_url              := http://xorg.freedesktop.org/releases/individual/app/$(xrandr).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXrandr)
	$(MAKE) -C $(builddir) install
