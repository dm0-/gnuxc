units                   := units-2.02
units_url               := http://ftp.gnu.org/gnu/units/$(units).tar.gz

configure-units-rule:
	cd $(units) && ./$(configure)

build-units-rule:
	$(MAKE) -C $(units) all

install-units-rule: $(call installed,readline)
	$(MAKE) -C $(units) install
