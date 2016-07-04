mpfr                    := mpfr-3.1.4
mpfr_sha1               := cedc0055d55b6ee4cd17e1e6119ed412520ff81a
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
