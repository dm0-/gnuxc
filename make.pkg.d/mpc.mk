mpc                     := mpc-1.0.3
mpc_sha1                := b8be66396c726fdc36ebb0f692ed8a8cca3bcc66
mpc_url                 := http://ftpmirror.gnu.org/mpc/$(mpc).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mpfr)
	$(MAKE) -C $(builddir) install
