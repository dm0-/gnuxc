mpfr                    := mpfr-3.1.2
mpfr_url                := http://ftp.gnu.org/gnu/mpfr/$(mpfr).tar.xz

configure-mpfr-rule: $(gmp)/fac_table.h $(gmp)/fib_table.h $(gmp)/mp_bases.h
	cd $(mpfr) && ./$(configure) \
		--enable-gmp-internals --with-gmp-build=$(CURDIR)/$(gmp) \
		\
		--enable-assert \
		--enable-thread-safe \
		--enable-warnings

build-mpfr-rule:
	$(MAKE) -C $(mpfr) all

install-mpfr-rule: $(call installed,gmp)
	$(MAKE) -C $(mpfr) install
