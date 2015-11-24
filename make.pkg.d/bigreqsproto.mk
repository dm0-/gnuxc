bigreqsproto            := bigreqsproto-1.1.2
bigreqsproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(bigreqsproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
