gmp                     := gmp-6.0.0a
gmp_branch              := gmp-6.0.0
gmp_url                 := http://ftpmirror.gnu.org/gmp/$(gmp).tar.lz

configure-gmp-rule:
	cd $(gmp) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-assembly \
		--enable-assert \
		--enable-cxx \
		--enable-fft

build-gmp-rule:
	$(MAKE) -C $(gmp) all

install-gmp-rule: $(call installed,glibc)
	$(MAKE) -C $(gmp) install \
		includeexecdir='$${includedir}'
