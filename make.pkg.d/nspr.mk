nspr                    := nspr-4.15
nspr_branch             := $(nspr)/nspr
nspr_sha1               := 56030e0177849034ba3027a23ae2a7f8ed41f379
nspr_url                := http://ftp.mozilla.org/pub/nspr/releases/v$(nspr:nspr-%=%)/src/$(nspr).tar.gz

ifeq ($(host),$(build))
export NSPR_CONFIG = /usr/bin/nspr-config
else
export NSPR_CONFIG = /usr/bin/$(host)-nspr-config
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
		--with-pthreads \
		HOST_CC=gcc

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install
