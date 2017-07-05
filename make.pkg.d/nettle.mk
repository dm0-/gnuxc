nettle                  := nettle-3.3
nettle_sha1             := bf2b4d3a41192ff6177936d7bc3bee4cebeb86c4
nettle_url              := http://ftpmirror.gnu.org/nettle/$(nettle).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-mini-gmp \
		--disable-openssl

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
