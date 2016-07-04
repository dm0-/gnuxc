libpng                  := libpng-1.6.23
libpng_sha1             := 4857fb8dbd5ca7ddacc40c183e340b9ffa34a097
libpng_url              := http://prdownloads.sourceforge.net/libpng/$(libpng).tar.xz

$(eval $(call verify-download,http://prdownloads.sourceforge.net/libpng-apng/$(libpng)-apng.patch.gz,74596877d780dc30a5a1b90bd8e3d05e97bc245f,apng.patch.gz))

ifeq ($(host),$(build))
export LIBPNG_CONFIG = /usr/bin/libpng-config
else
export LIBPNG_CONFIG = /usr/bin/$(host)-libpng-config
endif

$(prepare-rule):
	gzip -cd $(call addon-file,apng.patch.gz) | $(PATCH) -d $(builddir) -p1

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--with-binconfigs

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install
