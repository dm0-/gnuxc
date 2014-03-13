xtrans                  := xtrans-1.3.3
xtrans_url              := http://xorg.freedesktop.org/releases/individual/lib/$(xtrans).tar.bz2

configure-xtrans-rule:
	cd $(xtrans) && ./$(configure) \
		--enable-strict-compilation

build-xtrans-rule:
	$(MAKE) -C $(xtrans) all

install-xtrans-rule: $(call installed,xproto)
	$(MAKE) -C $(xtrans) install
