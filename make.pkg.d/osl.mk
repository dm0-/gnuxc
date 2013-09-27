osl                     := osl-0.8.4
osl_url                 := http://www.lri.fr/~bastoul/development/openscop/docs/$(osl).tar.gz

configure-osl-rule:
	cd $(osl) && ./$(configure) \
		--disable-silent-rules \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system

build-osl-rule:
	$(MAKE) -C $(osl) all

install-osl-rule: $(call installed,gmp)
	$(MAKE) -C $(osl) install
