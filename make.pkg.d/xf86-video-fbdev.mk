xf86-video-fbdev        := xf86-video-fbdev-0.4.4
xf86-video-fbdev_url    := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-video-fbdev).tar.bz2

configure-xf86-video-fbdev-rule:
	cd $(xf86-video-fbdev) && ./$(configure) \
		--disable-silent-rules \
		--enable-pciaccess \
		--enable-static \
		--enable-strict-compilation

build-xf86-video-fbdev-rule:
	$(MAKE) -C $(xf86-video-fbdev) all

install-xf86-video-fbdev-rule: $(call installed,xorg-server)
	$(MAKE) -C $(xf86-video-fbdev) install
