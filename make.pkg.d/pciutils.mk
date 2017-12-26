pciutils                := pciutils-3.5.6
pciutils_key            := 5558F9399CD7836850553C6EC28E7847ED70F82D
pciutils_url            := ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/$(pciutils).tar.gz
pciutils_sig            := $(pciutils_url).sign

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
