randrproto              := randrproto-1.4.0
randrproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(randrproto).tar.bz2

configure-randrproto-rule:
	cd $(randrproto) && ./$(configure) \
		--enable-strict-compilation

build-randrproto-rule:
	$(MAKE) -C $(randrproto) all

install-randrproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(randrproto) install
