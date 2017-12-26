xrandr                  := xrandr-1.5.0
xrandr_key              := BD68A042C603DDAD9AA354B0F56ACC8F09BA9635
xrandr_url              := http://xorg.freedesktop.org/releases/individual/app/$(xrandr).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXrandr)
	$(MAKE) -C $(builddir) install
