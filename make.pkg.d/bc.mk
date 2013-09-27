bc                      := bc-1.06.95
bc_url                  := http://alpha.gnu.org/gnu/bc/$(bc).tar.bz2

prepare-bc-rule:
	$(RM) $(bc)/configure

configure-bc-rule:
	cd $(bc) && ./$(configure) \
		--with-readline

build-bc-rule:
	$(MAKE) -C $(bc) all

install-bc-rule: $(call installed,readline)
	$(MAKE) -C $(bc) install
