inetutils               := inetutils-1.9.2
inetutils_url           := http://ftpmirror.gnu.org/inetutils/$(inetutils).tar.xz

prepare-inetutils-rule:
	$(EDIT) "s,\(LIBNCURSES=\)[^ ]*,\1'`$(NCURSES_CONFIG) --libs`'," $(inetutils)/configure

configure-inetutils-rule:
	cd $(inetutils) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-clients \
		--enable-ipv6 \
		--enable-libls \
		--enable-ncurses \
		--enable-readline \
		--enable-servers \
		--enable-threads=posix \
		--with-idn \
		--with-ncurses-include-dir="`$(NCURSES_CONFIG) --includedir`" \
		--without-included-regex \
		\
		--without-pam \
		--without-wrap
#		--disable-authentication \
#		--disable-encryption

build-inetutils-rule:
	$(MAKE) -C $(inetutils) all \
		inetdaemondir='$$(sbindir)'

install-inetutils-rule: $(call installed,libidn readline)
	$(MAKE) -C $(inetutils) install \
		inetdaemondir='$$(sbindir)'
	$(INSTALL) -Dpm 644 $(inetutils)/dmd.scm $(DESTDIR)/etc/dmd.d/syslogd.scm
	$(INSTALL) -Dpm 644 $(inetutils)/syslog.conf $(DESTDIR)/etc/syslog.conf
	$(INSTALL) -dm 755 $(DESTDIR)/etc/syslog.d
	$(INSTALL) -Dm 644 /dev/null $(DESTDIR)/var/log/messages
	$(INSTALL) -Dm 600 /dev/null $(DESTDIR)/var/log/secure
# Move the hostname command outside the /usr prefix.
	$(INSTALL) -Dpm 755 $(inetutils)/src/hostname $(DESTDIR)/bin/hostname
	$(SYMLINK) ../../bin/hostname $(DESTDIR)/usr/bin/hostname

# Provide a system service definition for "syslogd".
$(inetutils)/dmd.scm: | $(inetutils)
	$(ECHO) -e "(define syslogd-command\n  '"'("/usr/sbin/syslogd"' > $@
	$(ECHO) -e '    "--inet"\n    "--ipany"\n    "--mark=0"\n    "--no-detach"\n    "--no-forward"))' >> $@
	$(ECHO) -e '(make <service>\n  #:docstring "The syslogd service controls a system logging daemon."' >> $@
	$(ECHO) -e "  #:provides '(syslogd syslog)\n  #:requires '()" >> $@
	$(ECHO) -e '  #:start (make-forkexec-constructor syslogd-command)\n  #:stop (make-kill-destructor))' >> $@
$(call prepared,inetutils): $(inetutils)/dmd.scm

# Provide a syslog configuration for general system stuff.
$(inetutils)/syslog.conf: | $(inetutils)
	$(ECHO) -e '*.info;mail.none;authpriv.none\t\t/var/log/messages' > $@
	$(ECHO) -e 'authpriv.*\t\t\t\t/var/log/secure' >> $@
$(call prepared,inetutils): $(inetutils)/syslog.conf
