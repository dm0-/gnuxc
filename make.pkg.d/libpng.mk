libpng                  := libpng-1.6.30
libpng_sha1             := b6f8ac4d83116a87d8e10e15ec360dab8a898f5c
libpng_url              := http://prdownloads.sourceforge.net/libpng/$(libpng).tar.xz

$(eval $(call verify-download,http://prdownloads.sourceforge.net/libpng-apng/$(libpng)-apng.patch.gz,c7383571617c2774db67ed5a0b896bbe95a2d335,apng.patch.gz))

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
