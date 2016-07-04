units                   := units-2.13
units_sha1              := ff600c4c82654ff7dcfd6c64ae928b4e2298ddb5
units_url               := http://ftpmirror.gnu.org/units/$(units).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
