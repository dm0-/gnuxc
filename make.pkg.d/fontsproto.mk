fontsproto              := fontsproto-2.1.3
fontsproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(fontsproto).tar.bz2

configure-fontsproto-rule:
	cd $(fontsproto) && ./$(configure) \
		--enable-strict-compilation

build-fontsproto-rule:
	$(MAKE) -C $(fontsproto) all

install-fontsproto-rule: $(call installed,xproto)
	$(MAKE) -C $(fontsproto) install
