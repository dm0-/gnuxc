gmp                     := gmp-6.1.0
gmp_url                 := http://ftpmirror.gnu.org/gmp/$(gmp).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-assembly \
		--enable-assert \
		--enable-cxx \
		--enable-fft

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		includeexecdir='$${includedir}'
