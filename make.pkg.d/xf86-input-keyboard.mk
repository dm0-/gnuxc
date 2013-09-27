xf86-input-keyboard     := xf86-input-keyboard-1.7.0
xf86-input-keyboard_url := http://xorg.freedesktop.org/releases/individual/driver/$(xf86-input-keyboard).tar.bz2

prepare-xf86-input-keyboard-rule:
	$(PATCH) -d $(xf86-input-keyboard) < $(patchdir)/$(xf86-input-keyboard)-xkb-options.patch

configure-xf86-input-keyboard-rule:
	cd $(xf86-input-keyboard) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		--enable-strict-compilation

build-xf86-input-keyboard-rule:
	$(MAKE) -C $(xf86-input-keyboard) all

install-xf86-input-keyboard-rule: $(call installed,xorg-server)
	$(MAKE) -C $(xf86-input-keyboard) install
