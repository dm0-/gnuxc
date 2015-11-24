spice-protocol          := spice-protocol-0.12.10
spice-protocol_url      := http://www.spice-space.org/download/releases/$(spice-protocol).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
