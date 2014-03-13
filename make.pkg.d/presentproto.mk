presentproto            := presentproto-1.0
presentproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(presentproto).tar.bz2

configure-presentproto-rule:
	cd $(presentproto) && ./$(configure) \
		--enable-strict-compilation

build-presentproto-rule:
	$(MAKE) -C $(presentproto) all

install-presentproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(presentproto) install
