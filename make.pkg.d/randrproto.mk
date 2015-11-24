randrproto              := randrproto-1.5.0
randrproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(randrproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
