xf86-video-vesa         := xf86-video-vesa-2.3.3
xf86-video-vesa_url     := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-video-vesa).tar.bz2

configure-xf86-video-vesa-rule:
	cd $(xf86-video-vesa) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--enable-strict-compilation

build-xf86-video-vesa-rule:
	$(MAKE) -C $(xf86-video-vesa) all

install-xf86-video-vesa-rule: $(call installed,xorg-server)
	$(MAKE) -C $(xf86-video-vesa) install
