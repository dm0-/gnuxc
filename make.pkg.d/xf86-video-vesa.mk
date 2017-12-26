xf86-video-vesa         := xf86-video-vesa-2.3.4
xf86-video-vesa_key     := DD38563A8A8224537D1F90E45B8A2D50A0ECD0D3
xf86-video-vesa_url     := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-video-vesa).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-static \
		--enable-strict-compilation \
		CPPFLAGS=-I$(sysroot)/usr/include/xorg

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xorg-server)
	$(MAKE) -C $(builddir) install
