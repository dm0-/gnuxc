p11-kit                 := p11-kit-0.23.2
p11-kit_sha1            := 4da0d7b47935b6cb0f321dd00358b063ae42df71
p11-kit_url             := http://p11-glue.freedesktop.org/releases/$(p11-kit).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
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
