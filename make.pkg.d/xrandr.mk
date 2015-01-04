xrandr                  := xrandr-1.4.3
xrandr_url              := http://xorg.freedesktop.org/releases/individual/app/$(xrandr).tar.bz2

configure-xrandr-rule:
	cd $(xrandr) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-xrandr-rule:
	$(MAKE) -C $(xrandr) all

install-xrandr-rule: $(call installed,libXrandr)
	$(MAKE) -C $(xrandr) install
