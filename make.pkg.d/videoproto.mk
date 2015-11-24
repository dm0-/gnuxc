videoproto              := videoproto-2.3.2
videoproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(videoproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
