nettle                  := nettle-2.7.1
nettle_url              := http://ftpmirror.gnu.org/nettle/$(nettle).tar.gz

configure-nettle-rule:
	cd $(nettle) && ./$(configure) \
		--disable-openssl

build-nettle-rule:
	$(MAKE) -C $(nettle) all

install-nettle-rule: $(call installed,gmp)
	$(MAKE) -C $(nettle) install
