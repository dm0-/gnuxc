sudo                    := sudo-1.8.11p2
sudo_url                := http://www.sudo.ws/sudo/dist/$(sudo).tar.gz

prepare-sudo-rule:
# Fix linking.
	$(EDIT) 's/^TESTSUDOERS_LIBS *=.*/& -ldl/' $(sudo)/plugins/sudoers/Makefile.in
	$(EDIT) 's/^LIBS *=.*/& -ldl/' $(sudo)/src/Makefile.in
# Don't require a password for the wheel group.
	$(EDIT) '/%wheel .* NOPASSWD/s/^[# ]*//' $(sudo)/plugins/sudoers/sudoers.in

configure-sudo-rule:
	cd $(sudo) && ./$(configure) \
		--disable-noargs-shell \
		--disable-rpath \
		--enable-env-debug \
		--enable-env-reset \
		--enable-log-host \
		--enable-pie \
		--enable-shell-sets-home \
		--enable-warnings \
		--enable-zlib \
		--with-devel \
		--with-editor=emacs \
		--with-env-editor \
		--with-exempt=wheel \
		--with-insults --with-all-insults \
		--with-man \
		--with-noexec=/usr/lib/sudo/sudo_noexec.so \
		--with-plugindir=/usr/lib/sudo \
		--with-rundir=/var/lib/sudo \
		--with-secure-path=/usr/bin:/usr/sbin:/bin:/sbin \
		--with-umask=0022 \
		--without-lecture \
		--without-sendmail \
		\
		--disable-shared-libutil --enable-static-sudoers

build-sudo-rule:
	$(MAKE) -C $(sudo) all

install-sudo-rule: $(call installed,zlib)
	$(MAKE) -C $(sudo) install \
		INSTALL_OWNER=
	$(RMDIR) $(DESTDIR)/usr/libexec/sudo
	$(INSTALL) -Dpm 644 $(sudo)/syslog.conf $(DESTDIR)/etc/syslog.d/sudo.conf
	$(INSTALL) -Dm 600 /dev/null $(DESTDIR)/var/log/sudo.log

# Provide a syslog configuration to log "sudo" tagged messages.
$(sudo)/syslog.conf: | $(sudo)
	$(ECHO) -e '! sudo\n*.*\t\t\t\t\t/var/log/sudo.log' > $@
$(call prepared,sudo): $(sudo)/syslog.conf
