bc                      := bc-1.06.95
bc_sha1                 := 18717e0543b1dda779a71e6a812f11b8261a705a
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
