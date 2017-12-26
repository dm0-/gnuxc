isl                     := isl-0.18
isl_sha1                := 13237a66fc623517fc570408b90a11e60eb6b4b9
isl_url                 := http://isl.gforge.inria.fr/$(isl).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system \
		--with-int=gmp

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
