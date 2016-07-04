spice-protocol          := spice-protocol-0.12.11
spice-protocol_sha1     := 322177b3b7b8676a7349265319d4ed7ff31bc098
spice-protocol_url      := http://www.spice-space.org/download/releases/$(spice-protocol).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
