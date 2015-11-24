xtrans                  := xtrans-1.3.5
xtrans_url              := http://xorg.freedesktop.org/releases/individual/lib/$(xtrans).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
