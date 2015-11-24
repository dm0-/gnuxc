xf86-video-fbdev        := xf86-video-fbdev-0.4.4
xf86-video-fbdev_url    := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-video-fbdev).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-pciaccess \
		--enable-static \
		--enable-strict-compilation \
		CPPFLAGS=-I$(sysroot)/usr/include/xorg

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xorg-server)
	$(MAKE) -C $(builddir) install
