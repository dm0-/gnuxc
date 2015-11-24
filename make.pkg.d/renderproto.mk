renderproto             := renderproto-0.11.1
renderproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(renderproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
