nettle                  := nettle-3.1.1
nettle_url              := http://ftpmirror.gnu.org/nettle/$(nettle).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-mini-gmp \
		--disable-openssl

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
