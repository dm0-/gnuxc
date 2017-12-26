xf86-video-qxl          := xf86-video-qxl-0.1.5
xf86-video-qxl_key      := 94A9F75661F77A6168649B23A9D8C21429AC6C82
xf86-video-qxl_url      := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-video-qxl).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-static \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		CPPFLAGS=-I$(sysroot)/usr/include/xorg \
		\
		--disable-kms \
		--disable-udev \
		--disable-xspice

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,spice-protocol xorg-server)
	$(MAKE) -C $(builddir) install
