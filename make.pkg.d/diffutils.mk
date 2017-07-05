diffutils               := diffutils-3.6
diffutils_sha1          := 1287a553868b808ebfff3790a5cdc6fdf7cb2886
diffutils_url           := http://ftpmirror.gnu.org/diffutils/$(diffutils).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
