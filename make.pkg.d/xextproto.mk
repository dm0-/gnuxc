xextproto               := xextproto-7.2.1
xextproto_url           := http://xorg.freedesktop.org/releases/individual/proto/$(xextproto).tar.bz2

configure-xextproto-rule:
	cd $(xextproto) && ./$(configure) \
		--enable-strict-compilation

build-xextproto-rule:
	$(MAKE) -C $(xextproto) all

install-xextproto-rule: $(call installed,xproto)
	$(MAKE) -C $(xextproto) install
