xf86-input-mouse        := xf86-input-mouse-1.9.2
xf86-input-mouse_key    := 3C2C43D9447D5938EF4551EBE23B7E70B467F0BF
xf86-input-mouse_url    := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-input-mouse).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-static \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xorg-server)
	$(MAKE) -C $(builddir) install
