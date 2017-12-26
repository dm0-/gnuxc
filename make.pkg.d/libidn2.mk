libidn2                 := libidn2-2.0.4
libidn2_key             := 1CB27DBC98614B2D5841646D08302DB6A2670428
libidn2_url             := http://ftpmirror.gnu.org/libidn/$(libidn2).tar.lz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-doc \
		--disable-rpath \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libunistring)
	$(MAKE) -C $(builddir) install
