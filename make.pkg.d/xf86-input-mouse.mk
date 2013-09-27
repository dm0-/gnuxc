xf86-input-mouse        := xf86-input-mouse-1.9.0
xf86-input-mouse_url    := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-input-mouse).tar.bz2

configure-xf86-input-mouse-rule:
	cd $(xf86-input-mouse) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--enable-strict-compilation \
		--with-sdkdir='/usr/include/xorg'

build-xf86-input-mouse-rule:
	$(MAKE) -C $(xf86-input-mouse) all

install-xf86-input-mouse-rule: $(call installed,xorg-server)
	$(MAKE) -C $(xf86-input-mouse) install
