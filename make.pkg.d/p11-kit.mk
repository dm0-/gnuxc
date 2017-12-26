p11-kit                 := p11-kit-0.23.2
p11-kit_key             := C0F67099B808FB063E2C81117BFB1108D92765AF
p11-kit_url             := http://p11-glue.freedesktop.org/releases/$(p11-kit).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-debug=default \
		--enable-trust-module \
		--with-hash-impl=internal \
		--with-libffi \
		--with-libtasn1 \
		\
		--disable-static \
		--disable-strict \
		ac_cv_func_getauxval=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libffi libtasn1)
	$(MAKE) -C $(builddir) install
