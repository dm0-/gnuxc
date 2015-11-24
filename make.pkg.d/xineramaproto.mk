xineramaproto           := xineramaproto-1.2.1
xineramaproto_url       := http://xorg.freedesktop.org/releases/individual/proto/$(xineramaproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xextproto)
	$(MAKE) -C $(builddir) install
