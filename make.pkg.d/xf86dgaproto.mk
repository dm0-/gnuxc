xf86dgaproto            := xf86dgaproto-2.1
xf86dgaproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(xf86dgaproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
