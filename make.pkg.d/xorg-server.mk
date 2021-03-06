xorg-server             := xorg-server-1.19.6
xorg-server_key         := 995ED5C8A6138EB0961F18474C09DD83CAAA50B2
xorg-server_url         := http://xorg.freedesktop.org/releases/individual/xserver/$(xorg-server).tar.bz2

$(prepare-rule):
# Place drop-in configuration files in the config dir, and use CLOCK_MONOTONIC.
	$(EDIT) -e '/MONOTONIC_CLOCK=.*cross/s/=.*/=yes/' -e /sysconfigdir=/s/datadir/sysconfdir/ $(builddir)/configure
# Fix the install-headers target.
	$(ECHO) 'install-sdkHEADERS:' >> $(builddir)/Makefile.in
# Work around a missing configure condition.
	$(EDIT) 's/#include.*compositeext.h.*/#ifdef COMPOSITE\n&\n#endif/' $(builddir)/glx/glxscreens.c

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-suid-wrapper \
		--enable-debug \
		--enable-dga \
		--enable-dpms \
		--enable-glx \
		--enable-input-thread \
		--enable-int10-module \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-mitshm \
		--enable-pciaccess \
		--enable-present \
		--enable-record \
		--enable-secure-rpc \
		--enable-static \
		--enable-tcp-transport \
		--enable-unix-transport \
		--enable-vbe \
		--enable-vgahw \
		--enable-visibility \
		--enable-xcsecurity \
		--enable-xdm-auth-1 \
		--enable-xdmcp \
		--enable-xfree86-utils \
		--enable-xinerama \
		--enable-xnest \
		--enable-xorg \
		--enable-xres \
		--enable-xshmfence \
		--enable-xv \
		--enable-xvfb \
		--with-sha1=libnettle \
		--with-xkb-output='$${sharedstatedir}/X11/xkb' \
		\
		--disable-composite \
		--disable-dri \
		--disable-dri2 \
		--disable-dri3 \
		--disable-glamor \
		--disable-libdrm \
		--disable-libunwind \
		--disable-screensaver \
		--disable-selective-werror \
		--disable-strict-compilation \
		--disable-unit-tests

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bigreqsproto damageproto fixesproto libpciaccess libXdmcp libXext libXfont2 libXinerama libxkbfile libxshmfence mesa pixman presentproto randrproto recordproto renderproto resourceproto videoproto xcb-util-keysyms xcmiscproto xf86dgaproto)
	$(MAKE) -C $(builddir) install install-headers
	$(INSTALL) -Dpm 0644 $(call addon-file,tmpfiles.conf) $(DESTDIR)/usr/lib/tmpfiles.d/xorg-server.conf
# Lazily work around --enable-install-setuid requiring root.
	chmod 4755 $(DESTDIR)/usr/bin/Xorg

# Write inline files.
$(call addon-file,tmpfiles.conf): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,tmpfiles.conf)


# Provide the configuration to manage X's /tmp files as root.
$(call addon-file,tmpfiles.conf): private override contents := d /tmp/.X11-unix 1777
