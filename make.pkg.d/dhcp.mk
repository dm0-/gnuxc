dhcp                    := dhcp-4.3.3
dhcp_url                := http://ftp.isc.org/isc/$(subst -,/,$(dhcp))/$(dhcp).tar.gz

$(prepare-rule):
	$(EDIT) "s,^DEFS=,&'-D_GNU_SOURCE -DUSE_LPF_HWADDR "-D_PATH_DHCLIENT_SCRIPT='\\"/usr/sbin/dhclient-script\\"'" '," $(builddir)/configure
# Use the bundled BIND for now.
	$(TAR) -C $(builddir)/bind -xf $(builddir)/bind/bind.tar.gz
	$(EDIT) '/gen.c/s/CC/BUILD_&/' $(builddir)/bind/bind-[0-9]*/lib/export/dns/Makefile.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-debug \
		--enable-dhcpv6 \
		--enable-execute \
		--enable-failover \
		--enable-ipv4-pktinfo \
		--enable-secs-byteorder \
		--enable-tracing \
		--enable-use-sockets \
		\
		--without-ldap \
#		--without-libbind
	cd $(builddir)/bind/bind-[0-9]* && BUILD_CC=gcc CFLAGS="$$CFLAGS -D_GNU_SOURCE" ./$(configure) --disable-kqueue --disable-epoll --disable-devpoll --without-openssl --without-libxml2 --enable-exportlib --enable-threads=no --with-export-includedir=$(CURDIR)/$(builddir)/bind/include --with-export-libdir=$(CURDIR)/$(builddir)/bind/lib --with-gssapi=no --with-randomdev=/dev/random

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,setup)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,dhclient.scm) $(DESTDIR)/etc/dmd.d/dhclient.scm
	$(INSTALL) -Dpm 755 $(call addon-file,dhclient-hurd.sh) $(DESTDIR)/usr/sbin/dhclient-script

# Write inline files.
$(call addon-file,dhclient.scm dhclient-hurd.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,dhclient.scm dhclient-hurd.sh)


# Provide a system service definition for "dhclient".
override define contents
(define dhclient-command
  '("/usr/sbin/dhclient"
    "-d"))
(make <service>
  #:docstring "The dhclient service configures networking via DHCP."
  #:provides '(dhclient)
  #:requires '()
  #:start (make-forkexec-constructor dhclient-command)
  #:stop (make-kill-destructor))
endef
$(call addon-file,dhclient.scm): private override contents := $(value contents)


# Provide a client script for Hurd.
override define contents
#!/bin/bash -e

fsysopts=${FSYSOPTS:-fsysopts}
resolv=/etc/resolv.conf.dhclient
rm=${RM:-rm -f}
settrans=${SETTRANS:-settrans}
symlink=${SYMLINK:-/hurd/symlink}

preinit() {
        $settrans -afg /etc/resolv.conf
        $rm $resolv

        exec $fsysopts /servers/socket/2 ^
            ${interface:+--interface="$interface"} ^
            --address=0 --gateway=0 --netmask=0
}
bound() {
        for router in $new_routers
        do
                new_gateway=$router
                break # Only use the first router for now.
        done

        echo -n ${new_domain_name:+domain $new_domain_name$'\n'} > $resolv
        ${new_domain_search:+echo search $new_domain_search >> $resolv}
        for domain_name_server in $new_domain_name_servers
        do
                echo nameserver $domain_name_server >> $resolv
        done
        $settrans -afg /etc/resolv.conf $symlink $resolv

        exec $fsysopts /servers/socket/2 ^
            ${interface:+--interface="$interface"} ^
            --address="${new_ip_address:-0}" ^
            --netmask="${new_subnet_mask:-0}" ^
            --gateway="${new_gateway:-0}"
}
renew() { bound "$@" ; }
rebind() { bound "$@" ; }
reboot() { bound "$@" ; }
expire() { preinit "$@" ; }
fail() { expire "$@" ; }
stop() { expire "$@" ; }
release() { expire "$@" ; }
timeout() { bound "$@" ; }

case "$reason" in
    PREINIT|BOUND|RENEW|REBIND|REBOOT|EXPIRE|FAIL|STOP|RELEASE|TIMEOUT)
        ${reason,,}
        ;;
    MEDIUM|NBI)
        exit 0 # An unsupported reason was given.
        ;;
    *)
        exit 1 # An unknown reason was given.
        ;;
esac
endef
$(call addon-file,dhclient-hurd.sh): private override contents := $(subst ^,\,$(value contents))
