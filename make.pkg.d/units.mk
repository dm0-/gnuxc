units                   := units-2.11a
units_url               := http://alpha.gnu.org/gnu/units/$(units).tar.gz

configure-units-rule:
	cd $(units) && ./$(configure)

build-units-rule:
	$(MAKE) -C $(units) all

install-units-rule: $(call installed,readline)
	$(MAKE) -C $(units) install
