libpng                  := libpng-1.6.34
libpng_key              := 8048643BA2C840F4F92A195FF54984BFA16C640F
libpng_url              := http://prdownloads.sourceforge.net/libpng/$(libpng).tar.xz
libpng_sig              := $(libpng_url).asc

$(eval $(call verify-download,apng.patch.gz,http://prdownloads.sourceforge.net/libpng-apng/$(libpng)-apng.patch.gz,1223d63aebab9058f61c2d17e89265637a0c377f))

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
