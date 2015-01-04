isl                     := isl-0.14
isl_url                 := http://isl.gforge.inria.fr/$(isl).tar.xz

configure-isl-rule:
	cd $(isl) && ./$(configure) \
		--disable-silent-rules \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system \
		--with-int=gmp

build-isl-rule:
	$(MAKE) -C $(isl) all

install-isl-rule: $(call installed,gmp)
	$(MAKE) -C $(isl) install
