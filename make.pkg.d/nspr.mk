nspr                    := nspr-4.11
nspr_branch             := $(nspr)/nspr
nspr_url                := http://ftp.mozilla.org/pub/nspr/releases/v$(nspr:nspr-%=%)/src/$(nspr).tar.gz

ifeq ($(host),$(build))
export NSPR_CONFIG = nspr-config
else
export NSPR_CONFIG = $(host)-nspr-config
endif

$(prepare-rule):
	$(call apply,hurd-port)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-strip \
		--enable-cplus \
		--enable-debug --enable-debug-symbols \
		--enable-ipv6 \
		--enable-optimize \
		--with-pthreads

$(build-rule):
ifneq ($(host),$(build))
	$(MAKE) -C $(builddir)/config export CC=gcc
endif
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install
