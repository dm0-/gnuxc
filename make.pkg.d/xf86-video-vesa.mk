xf86-video-vesa         := xf86-video-vesa-2.3.4
xf86-video-vesa_sha1    := 88e74ccc5c11fdb60539bd474ba978eeb4f28a23
xf86-video-vesa_url     := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-video-vesa).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--enable-strict-compilation \
		CPPFLAGS=-I$(sysroot)/usr/include/xorg

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xorg-server)
	$(MAKE) -C $(builddir) install
