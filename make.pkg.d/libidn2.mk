libidn2                 := libidn2-2.0.2
libidn2_sha1            := 7c5d660f97383e46b6b736363ee4bf9f544b45a0
libidn2_url             := http://ftpmirror.gnu.org/libidn/$(libidn2).tar.lz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-doc \
		--disable-rpath \
		--disable-silent-rules \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libunistring)
	$(MAKE) -C $(builddir) install
