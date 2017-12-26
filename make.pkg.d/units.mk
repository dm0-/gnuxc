units                   := units-2.16
units_key               := 9AD8FC4162D7937CF64F972E1889D5F0E0636F49
units_url               := http://ftpmirror.gnu.org/units/$(units).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
