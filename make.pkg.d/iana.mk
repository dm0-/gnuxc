iana                    := iana-1

iana-tzcode_url         := http://www.iana.org/time-zones/repository/releases/tzcode2014j.tar.gz
iana-tzdata_url         := http://www.iana.org/time-zones/repository/releases/tzdata2014j.tar.gz

iana-protocols_url      := http://www.iana.org/assignments/protocol-numbers/protocol-numbers-1.csv
iana-services_url       := http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv

iana_configuration = \
	TOPDIR=/usr \
	ETCDIR='$$(TOPDIR)'/sbin \
	MANDIR='$$(TOPDIR)'/share/man \
	TZDIR='$$(TOPDIR)'/share/zoneinfo \
	TZDOBJS=zdump.o \
	AR='$(AR)' \
	cc='$(CC)' \
	CFLAGS='$(CFLAGS) -DHAVE_GETTEXT=1 -DHAVE_UTMPX_H=1 -DTHREAD_SAFE=1 -DUSE_LTZ=0' \
	LDFLAGS='$(LDFLAGS)' \
	RANLIB='$(RANLIB)'

ifneq ($(host),$(build))
iana_configuration += zic=./zic.build
endif

prepare-iana-rule:
	$(DOWNLOAD) '$(iana-tzdata_url)' | $(TAR) -zC $(iana) -x
	$(DOWNLOAD) '$(iana-tzcode_url)' | $(TAR) -zC $(iana) -x
	$(PATCH) -d $(iana) < $(patchdir)/$(iana)-adjust-install.patch

build-iana-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(iana) clean
	$(MAKE) -C $(iana) zic $(iana_configuration) AR=gcc-ar cc=gcc RANLIB=gcc-ranlib
	$(MOVE) $(iana)/zic $(iana)/zic.build
	$(MAKE) -C $(iana) clean
endif
	$(MAKE) -C $(iana) all $(iana_configuration)

$(iana)/protocols: $(iana)/protocols.csv
	$(BASH) $(iana)/convert-protocols.sh < $< > $@
$(iana)/services: $(iana)/services.csv
	$(BASH) $(iana)/convert-services.sh < $< > $@
$(call built,iana): $(iana)/protocols $(iana)/services

install-iana-rule: $(call installed,glibc)
	$(MAKE) -C $(iana) install $(iana_configuration)
	$(INSTALL) -Dpm 644 $(iana)/protocols $(DESTDIR)/etc/protocols
	$(INSTALL) -Dpm 644 $(iana)/services $(DESTDIR)/etc/services

# Fetch the list of registered protocols in CSV format.
$(iana)/protocols.csv: | $(iana)
	$(DOWNLOAD) '$(iana-protocols_url)' > $@
$(call prepared,iana): $(iana)/protocols.csv

# Fetch the list of registered services in CSV format.
$(iana)/services.csv: | $(iana)
	$(DOWNLOAD) '$(iana-services_url)' > $@
$(call prepared,iana): $(iana)/services.csv

# Provide a script to convert the protocols CSV file to glibc's format.
$(iana)/convert-protocols.sh: $(patchdir)/$(iana)-convert-protocols.sh | $(iana)
	$(COPY) $< $@
$(call prepared,iana): $(iana)/convert-protocols.sh

# Provide a script to convert the services CSV file to glibc's format.
$(iana)/convert-services.sh: $(patchdir)/$(iana)-convert-services.sh | $(iana)
	$(COPY) $< $@
$(call prepared,iana): $(iana)/convert-services.sh
