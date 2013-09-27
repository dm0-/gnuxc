xf86dgaproto            := xf86dgaproto-2.1
xf86dgaproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(xf86dgaproto).tar.bz2

configure-xf86dgaproto-rule:
	cd $(xf86dgaproto) && ./$(configure) \
		--enable-strict-compilation

build-xf86dgaproto-rule:
	$(MAKE) -C $(xf86dgaproto) all

install-xf86dgaproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(xf86dgaproto) install
