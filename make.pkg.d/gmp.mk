gmp                     := gmp-6.1.2
gmp_key                 := 343C2FF0FBEE5EC2EDBEF399F3599FF828C67298
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
