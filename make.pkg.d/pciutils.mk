pciutils                := pciutils-3.5.4
pciutils_sha1           := 097feb1afdc3a58b029f7636d07983cb66b7ab14
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
