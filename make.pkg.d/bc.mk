bc                      := bc-1.06.95
bc_url                  := http://alpha.gnu.org/gnu/bc/$(bc).tar.bz2

$(prepare-rule):
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
