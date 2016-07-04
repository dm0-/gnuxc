pciutils                := pciutils-3.5.1
pciutils_sha1           := 512f68df5ee6d661ebc209befdf89ecffcdcf69d
pciutils_url            := ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/$(pciutils).tar.gz

$(prepare-rule):
	$(call apply,environment)

$(configure-rule):
	$(MAKE) -C $(builddir) lib/config.mk \
		HOST=$(host) \
		DNS=yes \
		ZLIB=yes

$(build-rule):
	$(MAKE) -C $(builddir) all
	$(MAKE) -C $(builddir) lib/libpci.a PCILIB=libpci.a SHARED=no

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install install-lib
	$(MAKE) -C $(builddir) install-pcilib PCILIB=libpci.a
