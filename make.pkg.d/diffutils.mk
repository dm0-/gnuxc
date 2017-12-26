diffutils               := diffutils-3.6
diffutils_key           := 155D3FC500C834486D1EEA677FD9FCCB000BEEEE
diffutils_url           := http://ftpmirror.gnu.org/diffutils/$(diffutils).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
