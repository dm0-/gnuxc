xorg-server             := xorg-server-1.15.0
xorg-server_url         := http://xorg.freedesktop.org/releases/individual/xserver/$(xorg-server).tar.bz2

prepare-xorg-server-rule:
	$(PATCH) -d $(xorg-server) < $(patchdir)/$(xorg-server)-optional-xinerama.patch
	$(ECHO) 'install-sdkHEADERS:' >> $(xorg-server)/Makefile.in

configure-xorg-server-rule:
	cd $(xorg-server) && ./$(configure) \
		--disable-silent-rules \
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
		--enable-xnest \
		--enable-xorg \
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
		--disable-selective-werror \
		--disable-xinerama \
		--disable-xres

build-xorg-server-rule:
	$(MAKE) -C $(xorg-server) all

install-xorg-server-rule: $(call installed,bigreqsproto damageproto fixesproto libpciaccess libxcb libXdmcp libXext libXfont libxkbfile nettle pixman presentproto randrproto renderproto videoproto xcmiscproto xf86dgaproto)
	$(MAKE) -C $(xorg-server) install install-headers
# lazy work-around for install-setuid requiring root
	chmod u+s $(DESTDIR)/usr/bin/Xorg
