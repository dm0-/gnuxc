spice-protocol          := spice-protocol-0.12.6
spice-protocol_url      := http://www.spice-space.org/download/releases/$(spice-protocol).tar.bz2

configure-spice-protocol-rule:
	cd $(spice-protocol) && ./$(configure)

build-spice-protocol-rule:
	$(MAKE) -C $(spice-protocol) all

install-spice-protocol-rule: $(call installed,xproto)
	$(MAKE) -C $(spice-protocol) install
