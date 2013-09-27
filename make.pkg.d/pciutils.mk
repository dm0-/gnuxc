pciutils                := pciutils-3.2.0
pciutils_url            := ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/$(pciutils).tar.gz

prepare-pciutils-rule:
	$(PATCH) -d $(pciutils) < $(patchdir)/$(pciutils)-environment.patch

configure-pciutils-rule:
	$(MAKE) -C $(pciutils) lib/config.mk \
		HOST=$(host) \
		DNS=yes \
		ZLIB=yes

build-pciutils-rule:
	$(MAKE) -C $(pciutils) all
	$(MAKE) -C $(pciutils) lib/libpci.a PCILIB=libpci.a SHARED=no

install-pciutils-rule: $(call installed,zlib)
	$(MAKE) -C $(pciutils) install install-lib
	$(MAKE) -C $(pciutils) install-pcilib PCILIB=libpci.a
