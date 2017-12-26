osl                     := osl-0.9.1
osl_sha1                := b6dfc07098c0aa86fe113b343e7cd7c26829392b
osl_url                 := http://github.com/periscop/openscop/releases/download/$(osl:osl-%=%)/$(osl).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
