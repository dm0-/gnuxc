sudo                    := sudo-1.8.21p2
sudo_key                := 59D1E9CCBA2B376704FDD35BA9F4C021CEA470FB
sudo_url                := http://www.sudo.ws/sudo/dist/$(sudo).tar.gz

$(prepare-rule):
# Don't require a password for the wheel group.
	$(EDIT) '/%wheel .* NOPASSWD/s/^[# ]*//' $(builddir)/plugins/sudoers/sudoers.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-noargs-shell \
		--disable-rpath \
		--enable-asan \
		--enable-env-debug \
		--enable-env-reset \
		--enable-hardening \
		--enable-log-host \
		--enable-pie \
		--enable-shell-sets-home \
		--enable-tmpfiles.d \
		--enable-warnings --disable-werror \
		--enable-zlib \
		--with-devel \
		--with-editor=emacs \
		--with-env-editor \
		--with-exempt=wheel \
		--with-insults --with-all-insults \
		--with-man \
		--with-noexec=/usr/lib/sudo/sudo_noexec.so \
		--with-plugindir=/usr/lib/sudo \
		--with-rundir=/run/sudo \
		--with-secure-path=/usr/bin:/usr/sbin:/bin:/sbin \
		--with-umask=0022 \
		--without-lecture \
		--without-sendmail \
		\
		--disable-shared-libutil --enable-static-sudoers \
		CPPFLAGS='-DAT_FDCWD=0 -DUTIME_NOW=0 -DUTIME_OMIT=0 -DWCONTINUED=0'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install \
		INSTALL_OWNER=
	$(RMDIR) $(DESTDIR)/usr/libexec/sudo
	$(INSTALL) -Dpm 0644 $(call addon-file,syslog.conf) $(DESTDIR)/etc/syslog.d/sudo.conf
	$(INSTALL) -Dm 0600 /dev/null $(DESTDIR)/var/log/syslog/sudo.log

# Write inline files.
$(call addon-file,syslog.conf): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,syslog.conf)


# Provide a syslog configuration to log "sudo" tagged messages.
override define contents
! sudo
*.*					/var/log/syslog/sudo.log
endef
$(call addon-file,syslog.conf): private override contents := $(value contents)
