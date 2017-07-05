spice-protocol          := spice-protocol-0.12.13
spice-protocol_sha1     := df1eab603490ccc3275718dccc7c68a7732a4524
spice-protocol_url      := http://www.spice-space.org/download/releases/$(spice-protocol).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
