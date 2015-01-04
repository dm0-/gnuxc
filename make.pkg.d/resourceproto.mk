resourceproto           := resourceproto-1.2.0
resourceproto_url       := http://xorg.freedesktop.org/releases/individual/proto/$(resourceproto).tar.bz2

configure-resourceproto-rule:
	cd $(resourceproto) && ./$(configure) \
		--enable-strict-compilation

build-resourceproto-rule:
	$(MAKE) -C $(resourceproto) all

install-resourceproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(resourceproto) install
