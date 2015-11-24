fontsproto              := fontsproto-2.1.3
fontsproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(fontsproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
