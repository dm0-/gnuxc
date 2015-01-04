xorg-server             := xorg-server-1.16.3
xorg-server_url         := http://xorg.freedesktop.org/releases/individual/xserver/$(xorg-server).tar.bz2

prepare-xorg-server-rule:
	$(ECHO) 'install-sdkHEADERS:' >> $(xorg-server)/Makefile.in

configure-xorg-server-rule:
	cd $(xorg-server) && ./$(configure) \
		--disable-silent-rules \
		--disable-suid-wrapper \
		--enable-debug \
		--enable-dga \
		--enable-dpms \
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
		--disable-glx \
		--disable-record \
		--disable-screensaver \
		--disable-selective-werror

build-xorg-server-rule:
	$(MAKE) -C $(xorg-server) all

install-xorg-server-rule: $(call installed,bigreqsproto damageproto fixesproto libpciaccess libxcb libXdmcp libXext libXfont libXinerama libxkbfile nettle pixman presentproto randrproto renderproto resourceproto videoproto xcmiscproto xf86dgaproto)
	$(MAKE) -C $(xorg-server) install install-headers
	$(INSTALL) -Dpm 644 $(xorg-server)/tmpfiles.conf $(DESTDIR)/usr/lib/tmpfiles.d/xorg-server.conf
# Lazily work around --enable-install-setuid requiring root.
	chmod u+s $(DESTDIR)/usr/bin/Xorg

# Provide the configuration to manage X's /tmp files as root.
$(xorg-server)/tmpfiles.conf: | $(xorg-server)
	$(ECHO) 'd /tmp/.X11-unix 1777' > $@
$(call prepared,xorg-server): $(xorg-server)/tmpfiles.conf
