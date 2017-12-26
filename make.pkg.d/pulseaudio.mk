pulseaudio              := pulseaudio-11.1
pulseaudio_sha1         := 53bde72b6bfe715c19b1519db8845f7a58346b67
pulseaudio_url          := http://www.freedesktop.org/software/pulseaudio/releases/$(pulseaudio).tar.xz

$(prepare-rule):
# Avoid calling old streams ioctls in the Solaris module.
	$(EDIT) $(pulseaudio)/src/daemon/default.pa.in \
		-e 's/^load-module module-suspend-on-idle/#&/' \
		-e '/^load-module module-detect/s/detect.*/solaris channel_map=mono channels=1 format=ulaw rate=8000 record=no/'

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-legacy-database-entry-format \
		--disable-rpath \
		--disable-static-bins \
		--enable-glib2 \
		--enable-gtk3 \
		--enable-ipv6 \
		--enable-solaris \
		--enable-static \
		--enable-x11 \
		--with-database=gdbm \
		--with-speex \
		\
		--disable-oss-{output,wrapper}

$(build-rule):
	$(MAKE) -C $(builddir) all \
		pkglibdir=/usr/lib

$(install-rule): $$(call installed,gdbm glib json-c libSM libsndfile libtool libXtst)
	$(MAKE) -C $(builddir) install \
		pkglibdir=/usr/lib
	$(INSTALL) -Dpm 0644 $(call addon-file,syslog.conf) $(DESTDIR)/etc/syslog.d/pulseaudio.conf
	$(INSTALL) -Dm 0644 /dev/null $(DESTDIR)/var/log/syslog/pulseaudio.log
# Symlink the modules' libraries into the real libdir.
	cd $(DESTDIR)/usr/lib && $(SYMLINK) pulse-*/modules/lib*.so ./

# Write inline files.
$(call addon-file,syslog.conf): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,syslog.conf)


# Provide a syslog configuration to log "pulseaudio" tagged messages.
override define contents
! pulseaudio
*.*					/var/log/syslog/pulseaudio.log
endef
$(call addon-file,syslog.conf): private override contents := $(value contents)
