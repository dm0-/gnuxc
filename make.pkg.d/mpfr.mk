mpfr                    := mpfr-3.1.2
mpfr_url                := http://ftpmirror.gnu.org/mpfr/$(mpfr).tar.xz

configure-mpfr-rule:
	cd $(mpfr) && ./$(configure) \
		--enable-assert \
		--enable-thread-safe \
		--enable-warnings

build-mpfr-rule:
	$(MAKE) -C $(mpfr) all

install-mpfr-rule: $(call installed,gmp)
	$(MAKE) -C $(mpfr) install
