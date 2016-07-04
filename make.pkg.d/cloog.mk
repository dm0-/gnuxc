cloog                   := cloog-0.18.4
cloog_sha1              := 8f7568ca1873f8d55bb694c8b9b83f7f4c6c1aa5
cloog_url               := http://www.bastoul.net/cloog/pages/download/$(cloog).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system \
		--with-isl=system \
		--with-osl=system

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,isl osl)
	$(MAKE) -C $(builddir) install
