inputproto              := inputproto-2.3
inputproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(inputproto).tar.bz2

configure-inputproto-rule:
	cd $(inputproto) && ./$(configure) \
		--enable-strict-compilation

build-inputproto-rule:
	$(MAKE) -C $(inputproto) all

install-inputproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(inputproto) install
