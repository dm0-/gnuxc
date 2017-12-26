spice-protocol          := spice-protocol-0.12.13
spice-protocol_key      := 94A9F75661F77A6168649B23A9D8C21429AC6C82
spice-protocol_url      := http://www.spice-space.org/download/releases/$(spice-protocol).tar.bz2
spice-protocol_sig      := $(spice-protocol_url).sign

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
