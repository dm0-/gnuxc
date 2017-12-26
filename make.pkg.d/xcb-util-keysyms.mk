xcb-util-keysyms        := xcb-util-keysyms-0.4.0
xcb-util-keysyms_sha1   := ff02ee8ac22c53848af50c0a6a6b00feb002c1cb
xcb-util-keysyms_url    := http://xcb.freedesktop.org/dist/$(xcb-util-keysyms).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libxcb)
	$(MAKE) -C $(builddir) install
