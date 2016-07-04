isl                     := isl-0.17.1
isl_sha1                := 62ff0dfb53cdae7c03bb769abb9e7ced075488db
isl_url                 := http://isl.gforge.inria.fr/$(isl).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system \
		--with-int=gmp

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
