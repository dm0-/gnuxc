nettle                  := nettle-3.4
nettle_key              := 343C2FF0FBEE5EC2EDBEF399F3599FF828C67298
nettle_url              := http://ftpmirror.gnu.org/nettle/$(nettle).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-mini-gmp \
		--disable-openssl

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gmp)
	$(MAKE) -C $(builddir) install
