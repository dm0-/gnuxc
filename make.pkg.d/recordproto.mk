recordproto             := recordproto-1.14.2
recordproto_sha1        := 1f48c4b0004d8b133efd0498e8d88d68d3b9199c
recordproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(recordproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
