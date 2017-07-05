gmp                     := gmp-6.1.2
gmp_sha1                := 9dc6981197a7d92f339192eea974f5eca48fcffe
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
