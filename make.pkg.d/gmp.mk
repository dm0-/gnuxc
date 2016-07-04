gmp                     := gmp-6.1.1
gmp_sha1                := 4da491d63ef850a7662f41da27ad1ba99c2dbaa1
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
