libpng                  := libpng-1.6.6
libpng_url              := http://prdownloads.sourceforge.net/libpng/$(libpng).tar.xz

ifeq ($(host),$(build))
export LIBPNG_CONFIG = libpng-config
else
export LIBPNG_CONFIG = $(host)-libpng-config
endif

configure-libpng-rule:
	cd $(libpng) && ./$(configure) \
		--with-binconfigs

build-libpng-rule:
	$(MAKE) -C $(libpng) all

install-libpng-rule: $(call installed,zlib)
	$(MAKE) -C $(libpng) install
