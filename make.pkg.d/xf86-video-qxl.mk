xf86-video-qxl          := xf86-video-qxl-0.1.1
xf86-video-qxl_url      := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-video-qxl).tar.bz2

configure-xf86-video-qxl-rule:
	cd $(xf86-video-qxl) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		\
		--disable-xspice

build-xf86-video-qxl-rule:
	$(MAKE) -C $(xf86-video-qxl) all

install-xf86-video-qxl-rule: $(call installed,spice-protocol xorg-server)
	$(MAKE) -C $(xf86-video-qxl) install
