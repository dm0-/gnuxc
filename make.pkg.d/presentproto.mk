presentproto            := presentproto-1.0
presentproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(presentproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
