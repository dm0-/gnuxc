gmp                     := gmp-5.1.2
gmp_url                 := http://ftp.gnu.org/gnu/gmp/$(gmp).tar.lz

configure-gmp-rule:
	cd $(gmp) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-assert \
		--enable-cxx

$(gmp)/fac_table.h $(gmp)/fib_table.h $(gmp)/mp_bases.h: $(call configured,gmp)
	$(MAKE) -C $(@D) $(@F)

build-gmp-rule:
	$(MAKE) -C $(gmp) all

install-gmp-rule: $(call installed,glibc)
	$(MAKE) -C $(gmp) install \
		includeexecdir='$${includedir}'
