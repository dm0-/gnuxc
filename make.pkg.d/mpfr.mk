mpfr                    := mpfr-3.1.5
mpfr_sha1               := c0fab77c6da4cb710c81cc04092fb9bea11a9403
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
