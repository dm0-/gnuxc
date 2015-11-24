xf86-input-keyboard     := xf86-input-keyboard-1.8.1
xf86-input-keyboard_url := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-input-keyboard).tar.bz2

$(prepare-rule):
	$(call apply,xkb-options)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xorg-server)
	$(MAKE) -C $(builddir) install
