osl                     := osl-0.9.0
osl_sha1                := e3598dfa9a5c706d4700848d12c76e5f0af81bde
osl_url                 := http://icps.u-strasbg.fr/people/bastoul/public_html/development/openscop/docs/$(osl).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
