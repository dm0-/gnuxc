iana                    := iana-1

iana-tzcode_url         := http://www.iana.org/time-zones/repository/releases/tzcode2015g.tar.gz
iana-tzdata_url         := http://www.iana.org/time-zones/repository/releases/tzdata2015g.tar.gz

iana-protocols_url      := http://www.iana.org/assignments/protocol-numbers/protocol-numbers-1.csv
iana-services_url       := http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv

$(build-rule) $(install-rule): private override configuration = \
	TOPDIR=/usr \
	ETCDIR='$$(TOPDIR)'/sbin \
	MANDIR='$$(TOPDIR)'/share/man \
	TZDIR='$$(TOPDIR)'/share/zoneinfo \
	TZDOBJS=zdump.o \
	AR='$(AR)' \
	cc='$(CC)' \
	CFLAGS='$(CFLAGS) -DHAVE_GETTEXT=1 -DHAVE_UTMPX_H=1 -DTHREAD_SAFE=1 -DUSE_LTZ=0' \
	LDFLAGS='$(LDFLAGS)' \
	RANLIB='$(RANLIB)' \
	$(and $(filter-out $(host),$(build)),zic=./zic.build)

$(prepare-rule):
	$(DOWNLOAD) '$(iana-tzdata_url)' | $(TAR) -zC $(builddir) -x
	$(DOWNLOAD) '$(iana-tzcode_url)' | $(TAR) -zC $(builddir) -x
	$(call apply,adjust-install)

$(build-rule):
ifneq ($(host),$(build))
	$(MAKE) -C $(builddir) clean
	$(MAKE) -C $(builddir) zic $(configuration) AR=gcc-ar cc=gcc RANLIB=gcc-ranlib
	$(MOVE) $(builddir)/zic $(builddir)/zic.build
	$(MAKE) -C $(builddir) clean
endif
	$(MAKE) -C $(builddir) all $(configuration)

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install $(configuration)
	$(INSTALL) -Dpm 644 $(call addon-file,protocols) $(DESTDIR)/etc/protocols
	$(INSTALL) -Dpm 644 $(call addon-file,services) $(DESTDIR)/etc/services

# Write inline files.
$(call addon-file,convert-protocols.sh convert-services.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,convert-protocols.sh convert-services.sh)

# Fetch the lists of registered protocols and services in CSV format.
$(call addon-file,protocols.csv): | $$(@D)
	$(DOWNLOAD) '$(iana-protocols_url)' > $@
$(call addon-file,services.csv): | $$(@D)
	$(DOWNLOAD) '$(iana-services_url)' > $@
$(prepared): $(call addon-file,protocols.csv services.csv)

# Convert the lists into a format that can be installed into /etc.
$(call addon-file,protocols): $(call addon-file,protocols.csv convert-protocols.sh)
	$(BASH) $(call addon-file,convert-protocols.sh) < $< > $@
$(call addon-file,services): $(call addon-file,services.csv convert-services.sh)
	$(BASH) $(call addon-file,convert-services.sh) < $< > $@
$(built): $(call addon-file,protocols services)


# Provide a script to convert the protocols CSV file to glibc's format.
override define contents
#!/bin/bash

echo -n '# Automatically generated from IANA protocols registry on '
date -u '+%Y-%m-%d.'

tr '\n\r' ' \n' |
sed 's/^ *//;s/,,/,-,/' |
while IFS=, read -rs decimal keyword protocol reference
do
        [[ $decimal =~ ^[0-9]+$ ]] || continue

        keyword=${keyword// /-}
        [[ $keyword =~ ^-|Reserved$ ]] && continue
        (( ${#keyword} < 8 )) && keyword+='\t'

        protocol=$(echo -n $protocol | sed 's/[ \t]\+/ /g;s/^ *" *//;s/ *" *$//;s/""/"/g')

        echo -e "${keyword,,}\t$decimal\t$keyword\t# $protocol"
done
endef
$(call addon-file,convert-protocols.sh): private override contents := $(value contents)


# Provide a script to convert the services CSV file to glibc's format.
override define contents
#!/bin/bash

echo -n '# Automatically generated from IANA services registry on '
date -u '+%Y-%m-%d.'

cat - <(echo -n END,65536,,,) |
tr '\n\r' ' \n' |
sed 's/^ *//;s/,,/,-,/' |
LC_ALL=C sort -t, -k2n,2 -k3,3 |
while IFS=, read -rs name port transport description assignee
do
        [ "$name" == END ] && echo -e "${alt:-\t}# $olddesc" && continue

        name=${name##*\(} name=${name%%\)*} name=${name//\ /-}
        [ -n "$name" ] || continue

        [[ $port =~ ^[0-9]+$ ]] && [ "$transport" != - ] || continue
        (( ${#port} + ${#transport} < 7 )) && transport+='\t'

        [ "$oldport" == "$port/$transport" ] && alt+="${alt:+ }$name" && continue
        (( ${#name} <  8 )) && name+='\t'
        (( ${#alt}  >= 8 )) && alt+=' '
        (( ${#alt}  <  8 )) && alt+='\t'
        echo -en "${olddesc:+$alt# $olddesc\n}$name\t$port/$transport\t"

        alt=
        olddesc=$(echo -n $description | sed 's/[ \t]\+/ /g;s/^ *" *//;s/ *" *$//;s/""/"/g')
        oldport="$port/$transport"
done
endef
$(call addon-file,convert-services.sh): private override contents := $(value contents)
