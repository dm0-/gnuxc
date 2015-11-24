xcb-proto               := xcb-proto-1.11
xcb-proto_url           := http://xcb.freedesktop.org/dist/$(xcb-proto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule):
	$(MAKE) -C $(builddir) install
