units                   := units-2.14
units_sha1              := de240d52855094ae2b64071ffc55ae1c3fc459f0
units_url               := http://ftpmirror.gnu.org/units/$(units).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
