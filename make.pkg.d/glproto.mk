glproto                 := glproto-1.4.17
glproto_url             := http://xorg.freedesktop.org/releases/individual/proto/$(glproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
