xorg-server             := xorg-server-1.18.0
xorg-server_url         := http://xorg.freedesktop.org/releases/individual/xserver/$(xorg-server).tar.bz2

$(prepare-rule):
# Fix memory corruption (sometimes segfaults when client programs are started).
	$(DOWNLOAD) 'http://bugs.freedesktop.org/attachment.cgi?id='117194 | $(PATCH) -d $(builddir) -p1
# Fix the install-headers target.
	$(ECHO) 'install-sdkHEADERS:' >> $(builddir)/Makefile.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--disable-suid-wrapper \
		--enable-debug \
		--enable-dga \
		--enable-dpms \
		--enable-glx \
		--enable-int10-module \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-mitshm \
		--enable-pciaccess \
		--enable-present \
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
		--enable-xv \
		--enable-xvfb \
		--with-sha1=libnettle \
		--with-xkb-output='$${sharedstatedir}/X11/xkb' \
		\
		--disable-aiglx \
		--disable-composite \
		--disable-dri \
		--disable-dri2 \
		--disable-dri3 \
		--disable-libdrm \
		--disable-libunwind \
		--disable-record \
		--disable-screensaver \
		--disable-selective-werror \
		--disable-strict-compilation \
		--disable-unit-tests \
		CFLAGS='$(CFLAGS) -O0 -g3'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bigreqsproto damageproto fixesproto libpciaccess libXdmcp libXext libXfont libXinerama libxkbfile mesa nettle pixman presentproto randrproto renderproto resourceproto videoproto xcb-util-keysyms xcmiscproto xf86dgaproto)
	$(MAKE) -C $(builddir) install install-headers
	$(INSTALL) -Dpm 644 $(call addon-file,tmpfiles.conf) $(DESTDIR)/usr/lib/tmpfiles.d/xorg-server.conf
# Lazily work around --enable-install-setuid requiring root.
	chmod 4755 $(DESTDIR)/usr/bin/Xorg

# Provide the configuration to manage X's /tmp files as root.
$(call addon-file,tmpfiles.conf): | $$(@D)
	$(ECHO) 'd /tmp/.X11-unix 1777' > $@
$(prepared): $(call addon-file,tmpfiles.conf)
