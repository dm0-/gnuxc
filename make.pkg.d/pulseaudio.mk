pulseaudio              := pulseaudio-10.0
pulseaudio_sha1         := ab7cc41a2dc2b9da0794e3a51a4eb7e82e7da511
pulseaudio_url          := http://www.freedesktop.org/software/pulseaudio/releases/$(pulseaudio).tar.xz

$(prepare-rule):
# Don't expect Solaris headers.
	$(EDIT) 's,<sys/conf.h>,<poll.h>,' $(builddir)/src/modules/module-solaris.c
#	cd $(builddir) && autopoint --force && AUTOPOINT='intltoolize --automake --copy' $(AUTOGEN)
# Avoid calling old streams ioctls in the Solaris module.
	$(EDIT) $(pulseaudio)/src/daemon/default.pa.in \
		-e 's/^load-module module-suspend-on-idle/#&/' \
		-e '/^load-module module-detect/s/detect.*/solaris channel_map=mono channels=1 format=ulaw rate=8000 record=no/'

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-legacy-database-entry-format \
		--disable-rpath \
		--disable-silent-rules \
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
	cd $(DESTDIR)/usr/lib && $(SYMLINK) $(pulseaudio:pulseaudio-%=pulse-%)/modules/lib*.so ./

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
