xf86-input-mouse        := xf86-input-mouse-1.9.2
xf86-input-mouse_sha1   := d3a0839ad5a33665bb261a4fba33e3a6271817dc
xf86-input-mouse_url    := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-input-mouse).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xorg-server)
	$(MAKE) -C $(builddir) install
