nspr                    := nspr-4.10.7
nspr_branch             := $(nspr)/nspr
nspr_url                := http://ftp.mozilla.org/pub/nspr/releases/v$(nspr:nspr-%=%)/src/$(nspr).tar.gz

ifeq ($(host),$(build))
export NSPR_CONFIG = nspr-config
else
export NSPR_CONFIG = $(host)-nspr-config
endif

prepare-nspr-rule:
# Make the pthread definition usage more POSIX-friendly.
	$(DOWNLOAD) 'http://hg.mozilla.org/projects/nspr/raw-rev/1fcea1618bb7' | $(PATCH) -d $(nspr) -p1
	$(PATCH) -d $(nspr) < $(patchdir)/$(nspr)-hurd-port.patch

configure-nspr-rule:
	cd $(nspr) && ./$(configure) \
		--disable-strip \
		--enable-cplus \
		--enable-debug --enable-debug-symbols \
		--enable-ipv6 \
		--enable-optimize \
		--with-pthreads

build-nspr-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(nspr)/config export CC=gcc
endif
	$(MAKE) -C $(nspr) all

install-nspr-rule: $(call installed,gcc)
	$(MAKE) -C $(nspr) install
