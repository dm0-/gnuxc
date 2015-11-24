damageproto             := damageproto-1.2.1
damageproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(damageproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
