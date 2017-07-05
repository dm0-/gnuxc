nss                     := nss-3.31
nss_branch              := $(nss)/nss
nss_sha1                := 006a13a5e52867c49ea1e7d986b7c02a3cd8ebfb
nss_url                 := http://ftp.mozilla.org/pub/security/nss/releases/NSS_$(subst .,_,$(nss:nss-%=%))_RTM/src/$(nss).tar.gz

ifeq ($(host),$(build))
export NSS_CONFIG = /usr/bin/nss-config
else
export NSS_CONFIG = /usr/bin/$(host)-nss-config
endif

$(build-rule): private override configuration = \
	ARCHFLAG= \
	BUILD_OPT=1 \
	BUILD_TREE='$(CURDIR)/$(builddir)' \
	CC='$(CC)' \
	MOZ_DEBUG_SYMBOLS=1 \
	NSPR_INCLUDE_DIR="`$(PKG_CONFIG) --cflags-only-I nspr | $(SED) s/^-I//`" \
	NSS_DISABLE_GTESTS=1 \
	NSS_ENABLE_WERROR=0 \
	NSS_USE_SYSTEM_SQLITE=1 \
	OBJDIR_NAME=gnu \
	USE_PTHREADS=1 \
	USE_SYSTEM_ZLIB=1

$(prepare-rule):
	$(call apply,hurd-port)

$(configure-rule):
	$(EDIT) $(builddir)/nss.pc $(builddir)/nss-config \
		-e 's/@NSS_MAJOR_VERSION@/$(word 1,$(subst ., ,$(nss:nss-%=%)))/g' \
		-e 's/@NSS_MINOR_VERSION@/$(word 2,$(subst ., ,$(nss:nss-%=%)))/g' \
		-e 's/@NSS_PATCH_VERSION@/$(word 3,$(subst ., ,$(nss:nss-%=%)))/g' \
		-e 's/@PKG_CONFIG@/pkg-config/g' \
		-e 's,@prefix@,/usr,g'

$(build-rule):
ifneq ($(host),$(build))
	$(MAKE) -C $(builddir)/coreconf/nsinstall -j1 libs $(configuration) CC=gcc
	$(MAKE) -C $(builddir)/lib/freebl -j1 export $(configuration)
	$(MAKE) -C $(builddir)/lib/util -j1 export $(configuration)
	$(MAKE) -C $(builddir)/cmd/shlibsign -j1 libs $(configuration) CC=gcc DIRS= NSS_BUILD_WITHOUT_SOFTOKEN=1
endif
	$(MAKE) -C $(builddir) -j1 all $(configuration)
ifneq ($(host),$(build))
	$(RM) $(builddir)/nss/shlibsign{.o,}
	$(MAKE) -C $(builddir)/cmd/shlibsign -j1 libs $(configuration) DIRS=
endif

$(install-rule): $$(call installed,nspr sqlite zlib)
	$(INSTALL) -dm 755 $(DESTDIR)/usr/bin $(DESTDIR)/usr/lib $(DESTDIR)/usr/include/nss
	$(INSTALL) -pm 755 -t $(DESTDIR)/usr/bin $(builddir)/dist/gnu/bin/*
	$(INSTALL) -Dpm 755 $(builddir)/nss-config $(DESTDIR)/usr/bin/nss-config
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/include/nss $(builddir)/dist/public/nss/*
	$(INSTALL) -pm 755 -t $(DESTDIR)/usr/lib $(builddir)/dist/gnu/lib/*.so
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/lib $(builddir)/dist/gnu/lib/*.{a,chk}
	$(INSTALL) -Dpm 644 $(builddir)/nss.pc $(DESTDIR)/usr/lib/pkgconfig/nss.pc
