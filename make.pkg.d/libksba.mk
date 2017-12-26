libksba                 := libksba-1.3.5
libksba_key             := D8692123C4065DEA5E0F3AB5249B39D24F25E3B6
libksba_url             := ftp://ftp.gnupg.org/gcrypt/libksba/$(libksba).tar.bz2

ifeq ($(host),$(build))
export KSBA_CONFIG = /usr/bin/ksba-config
else
export KSBA_CONFIG = /usr/bin/$(host)-ksba-config
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-static

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libgpg-error)
	$(MAKE) -C $(builddir) install
