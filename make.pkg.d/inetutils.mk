inetutils               := inetutils-1.9.4
inetutils_key           := 4FBD67621082C4C502448E3B180551BAD95A3C35
inetutils_url           := http://ftpmirror.gnu.org/inetutils/$(inetutils).tar.xz

$(prepare-rule):
	$(EDIT) 's,\(LIBNCURSES=\)[^ )]*,\1"$$NCURSES_ENVLIBS",' $(builddir)/configure $(builddir)/am/libcurses.m4
	$(TOUCH) --reference=$(builddir)/am/readline.m4 $(builddir)/am/libcurses.m4

$(configure-rule):
	cd $(builddir) && NCURSES_ENVLIBS="`$(NCURSES_CONFIG) --libs`" ./$(configure) \
		--disable-rpath \
		--enable-clients \
		--enable-ipv6 \
		--enable-libls \
		--enable-ncurses \
		--enable-readline \
		--enable-servers \
		--enable-threads=posix \
		--with-ncurses-include-dir="`$(NCURSES_CONFIG) --includedir`" \
		--without-included-regex \
		\
		--without-idn \
		--without-pam \
		--without-wrap
#		--disable-authentication \
#		--disable-encryption

$(build-rule):
	$(MAKE) -C $(builddir) all \
		inetdaemondir='$$(sbindir)'

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install \
		inetdaemondir='$$(sbindir)'
	chmod 4755 $(DESTDIR)/usr/bin/ping $(DESTDIR)/usr/bin/ping6
	$(INSTALL) -Dpm 0644 $(call addon-file,syslogd.scm) $(DESTDIR)/etc/shepherd.d/syslogd.scm
	$(INSTALL) -Dpm 0644 $(call addon-file,syslog.conf) $(DESTDIR)/etc/syslog.conf
	$(INSTALL) -dm 0755 $(DESTDIR)/etc/syslog.d
	$(INSTALL) -Dm 0600 /dev/null $(DESTDIR)/var/log/messages
	$(INSTALL) -Dm 0600 /dev/null $(DESTDIR)/var/log/secure
	$(call enable-service,syslogd,3 5)
# Create the syslog socket in /run until /dev is a special tmpfs.
	$(INSTALL) -dm 0755 $(DESTDIR)/dev
	$(SYMLINK) ../run/log $(DESTDIR)/dev/log
# Move the hostname command outside the /usr prefix.
	$(INSTALL) -Dpm 0755 $(builddir)/src/hostname $(DESTDIR)/bin/hostname
	$(SYMLINK) ../../bin/hostname $(DESTDIR)/usr/bin/hostname

# Write inline files.
$(call addon-file,syslog.conf syslogd.scm): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,syslog.conf syslogd.scm)


# Provide a syslog configuration for general system stuff.
override define contents
*.info;mail.none;authpriv.none		/var/log/messages
authpriv.*				/var/log/secure
endef
$(call addon-file,syslog.conf): private override contents := $(value contents)


# Provide a system service definition for "syslogd".
override define contents
(define syslogd-command
  '("/usr/sbin/syslogd"
    "--inet"
    "--ipany"
    "--mark=0"
    "--no-detach"
    "--no-forward"
    "--socket=/run/log"))
(make <service>
  #:docstring "The syslogd service controls a system logging daemon."
  #:provides '(syslogd syslog)
  #:requires '()
  #:start (make-forkexec-constructor syslogd-command)
  #:stop (make-kill-destructor))
endef
$(call addon-file,syslogd.scm): private override contents := $(value contents)
