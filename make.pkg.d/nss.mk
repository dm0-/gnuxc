nss                     := nss-3.17.3
nss_branch              := $(nss)/nss
nss_url                 := http://ftp.mozilla.org/pub/security/nss/releases/NSS_$(subst .,_,$(nss:nss-%=%))_RTM/src/$(nss).tar.gz

ifeq ($(host),$(build))
export NSS_CONFIG = nss-config
else
export NSS_CONFIG = $(host)-nss-config
endif

nss_configuration = \
	ARCHFLAG= \
	BUILD_OPT=1 \
	BUILD_TREE='$(CURDIR)/$(nss)' \
	CC='$(CC)' \
	MOZ_DEBUG_SYMBOLS=1 \
	NSPR_INCLUDE_DIR="`$(PKG_CONFIG) --cflags-only-I nspr | $(SED) s/^-I//`" \
	NSS_DISABLE_DBM=1 \
	NSS_USE_SYSTEM_SQLITE=1 \
	OBJDIR_NAME=gnu \
	USE_PTHREADS=1 \
	USE_SYSTEM_ZLIB=1

prepare-nss-rule:
	$(PATCH) -d $(nss) < $(patchdir)/$(nss)-hurd-port.patch

configure-nss-rule:
	$(EDIT) $(nss)/nss.pc $(nss)/nss-config \
		-e 's/@NSS_MAJOR_VERSION@/$(word 1,$(subst ., ,$(nss:nss-%=%)))/g' \
		-e 's/@NSS_MINOR_VERSION@/$(word 2,$(subst ., ,$(nss:nss-%=%)))/g' \
		-e 's/@NSS_PATCH_VERSION@/$(word 3,$(subst ., ,$(nss:nss-%=%)))/g' \
		-e 's/@PKG_CONFIG@/pkg-config/g' \
		-e 's,@prefix@,/usr,g'

build-nss-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(nss)/coreconf/nsinstall -j1 libs $(nss_configuration) CC=gcc
	$(MAKE) -C $(nss)/lib/freebl -j1 export $(nss_configuration)
	$(MAKE) -C $(nss)/lib/util -j1 export $(nss_configuration)
	$(MAKE) -C $(nss)/cmd/shlibsign -j1 libs $(nss_configuration) CC=gcc DIRS= NSS_BUILD_WITHOUT_SOFTOKEN=1
endif
	$(MAKE) -C $(nss) -j1 all $(nss_configuration)
ifneq ($(host),$(build))
	$(RM) $(nss)/nss/shlibsign{.o,}
	$(MAKE) -C $(nss)/cmd/shlibsign -j1 libs $(nss_configuration) DIRS=
endif

install-nss-rule: $(call installed,nspr sqlite zlib)
	$(INSTALL) -dm 755 $(DESTDIR)/usr/bin $(DESTDIR)/usr/lib $(DESTDIR)/usr/include/nss
	$(INSTALL) -pm 755 -t $(DESTDIR)/usr/bin $(nss)/dist/gnu/bin/*
	$(INSTALL) -Dpm 755 $(nss)/nss-config $(DESTDIR)/usr/bin/nss-config
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/include/nss $(nss)/dist/public/nss/*
	$(INSTALL) -pm 755 -t $(DESTDIR)/usr/lib $(nss)/dist/gnu/lib/*.so
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/lib $(nss)/dist/gnu/lib/*.{a,chk}
	$(INSTALL) -Dpm 644 $(nss)/nss.pc $(DESTDIR)/usr/lib/pkgconfig/nss.pc
