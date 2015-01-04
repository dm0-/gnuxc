osl                     := osl-0.9.0
osl_url                 := http://icps.u-strasbg.fr/people/bastoul/public_html/development/openscop/docs/$(osl).tar.gz

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
