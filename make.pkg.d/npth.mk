npth                    := npth-1.5
npth_key                := D8692123C4065DEA5E0F3AB5249B39D24F25E3B6
npth_url                := ftp://ftp.gnupg.org/gcrypt/npth/$(npth).tar.bz2

ifeq ($(host),$(build))
export NPTH_CONFIG = /usr/bin/npth-config
else
export NPTH_CONFIG = /usr/bin/$(host)-npth-config
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-static

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
