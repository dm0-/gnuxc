mpc                     := mpc-1.0.3
mpc_url                 := http://ftpmirror.gnu.org/mpc/$(mpc).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mpfr)
	$(MAKE) -C $(builddir) install
