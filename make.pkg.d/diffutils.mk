diffutils               := diffutils-3.3
diffutils_sha1          := 6463cce7d3eb73489996baefd0e4425928ecd61e
diffutils_url           := http://ftpmirror.gnu.org/diffutils/$(diffutils).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
