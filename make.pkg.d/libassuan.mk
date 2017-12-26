libassuan               := libassuan-2.5.1
libassuan_key           := D8692123C4065DEA5E0F3AB5249B39D24F25E3B6
libassuan_url           := ftp://ftp.gnupg.org/gcrypt/libassuan/$(libassuan).tar.bz2

ifeq ($(host),$(build))
export LIBASSUAN_CONFIG = /usr/bin/libassuan-config
else
export LIBASSUAN_CONFIG = /usr/bin/$(host)-libassuan-config
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-static

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libgpg-error)
	$(MAKE) -C $(builddir) install
