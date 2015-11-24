xextproto               := xextproto-7.3.0
xextproto_url           := http://xorg.freedesktop.org/releases/individual/proto/$(xextproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
