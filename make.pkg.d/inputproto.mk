inputproto              := inputproto-2.3.1
inputproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(inputproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
