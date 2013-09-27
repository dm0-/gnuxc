fixesproto              := fixesproto-5.0
fixesproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(fixesproto).tar.bz2

configure-fixesproto-rule:
	cd $(fixesproto) && ./$(configure) \
		--enable-strict-compilation

build-fixesproto-rule:
	$(MAKE) -C $(fixesproto) all

install-fixesproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(fixesproto) install
