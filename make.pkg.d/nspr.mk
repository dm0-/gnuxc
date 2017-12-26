nspr                    := nspr-4.17
nspr_branch             := $(nspr)/nspr
nspr_sha1               := 5262abb243191d5fa3dcd72857d7d7f8ec47ad01
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
		HOST_CC=gcc HOST_CFLAGS='$(CFLAGS_FOR_BUILD)' HOST_LDFLAGS='$(LDFLAGS_FOR_BUILD)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install
