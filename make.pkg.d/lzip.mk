lzip                    := lzip-1.14
lzip_url                := http://download.savannah.gnu.org/releases/lzip/$(lzip).tar.lz

prepare-lzip-rule:
	$(PATCH) -d $(lzip) < $(patchdir)/$(lzip)-environment.patch

configure-lzip-rule:
	cd $(lzip) && ./$(configure)

build-lzip-rule:
	$(MAKE) -C $(lzip) all

install-lzip-rule: $(call installed,gcc)
	$(MAKE) -C $(lzip) install
