nettle                  := nettle-3.2
nettle_sha1             := b2eb5b36e65a8d3ed60ff81ec897044dead6dae0
nettle_url              := http://ftpmirror.gnu.org/nettle/$(nettle).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-mini-gmp \
		--disable-openssl

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
