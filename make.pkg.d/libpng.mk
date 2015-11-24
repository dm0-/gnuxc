libpng                  := libpng-1.6.19
libpng_url              := http://prdownloads.sourceforge.net/libpng/$(libpng).tar.xz

ifeq ($(host),$(build))
export LIBPNG_CONFIG = libpng-config
else
export LIBPNG_CONFIG = $(host)-libpng-config
endif

$(prepare-rule):
	$(DOWNLOAD) 'http://prdownloads.sourceforge.net/libpng-apng/$(libpng)-apng.patch.gz' | gzip -d | $(PATCH) -d $(builddir) -p1

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--with-binconfigs

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install
