xcb-proto               := xcb-proto-1.8
xcb-proto_url           := http://xcb.freedesktop.org/dist/$(xcb-proto).tar.bz2

configure-xcb-proto-rule:
	cd $(xcb-proto) && ./$(configure)

build-xcb-proto-rule:
	$(MAKE) -C $(xcb-proto) all

install-xcb-proto-rule: # $(call installed,python)
	$(MAKE) -C $(xcb-proto) install
