iana                    := iana-1

iana_configuration := \
	TOPDIR=/usr \
	ETCDIR='$$(TOPDIR)'/sbin \
	MANDIR='$$(TOPDIR)'/share/man \
	TZDIR='$$(TOPDIR)'/share/zoneinfo

ifeq ($(host),$(build))
iana_configuration += zic=./zic
else
iana_configuration += zic=zic
endif

prepare-iana-rule:
	$(DOWNLOAD) 'http://www.iana.org/time-zones/repository/releases/tzdata2013f.tar.gz' | $(TAR) -zC $(iana) -x
	$(DOWNLOAD) 'http://www.iana.org/time-zones/repository/releases/tzcode2013f.tar.gz' | $(TAR) -zC $(iana) -x
	$(PATCH) -d $(iana) < $(patchdir)/$(iana)-environment.patch

	$(DOWNLOAD) 'http://www.iana.org/assignments/protocol-numbers/protocol-numbers-1.csv' > $(iana)/protocols.csv
	$(DOWNLOAD) 'http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv' > $(iana)/services.csv

	$(COPY) $(patchdir)/$(iana)-convert-protocols.sh $(iana)/convert-protocols.sh
	$(COPY) $(patchdir)/$(iana)-convert-services.sh $(iana)/convert-services.sh
	chmod 755 $(iana)/convert-*.sh

$(iana)/protocols: $(call configured,iana)
	$(iana)/convert-protocols.sh < $@.csv > $@
$(iana)/services: $(call configured,iana)
	$(iana)/convert-services.sh < $@.csv > $@

build-iana-rule: $(iana)/protocols $(iana)/services
	$(MAKE) -C $(iana) all $(iana_configuration)

install-iana-rule: $(call installed,glibc)
	$(MAKE) -C $(iana) install $(iana_configuration)
	$(INSTALL) -Dpm 644 $(iana)/protocols $(DESTDIR)/etc/protocols
	$(INSTALL) -Dpm 644 $(iana)/services $(DESTDIR)/etc/services
