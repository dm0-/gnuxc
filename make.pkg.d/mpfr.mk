mpfr                    := mpfr-3.1.3
mpfr_url                := http://ftpmirror.gnu.org/mpfr/$(mpfr).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-assert \
		--enable-thread-safe \
		--enable-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
