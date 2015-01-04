xdm                     := xdm-1.1.11
xdm_url                 := http://xorg.freedesktop.org/releases/individual/app/$(xdm).tar.bz2

prepare-xdm-rule:
	$(PATCH) -d $(xdm) < $(patchdir)/$(xdm)-empty-shadow-pass.patch

configure-xdm-rule:
	cd $(xdm) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-secure-rpc \
		--enable-static \
		--enable-tcp-transport \
		--enable-unix-transport \
		--enable-xdm-auth \
		--enable-xdmshell \
		--enable-xpm-logos \
		--with-authdir='$${sharedstatedir}/X11/xdm' \
		--with-pixmapdir=/usr/share/pixmaps \
		--with-random-device=/dev/urandom \
		--with-utmp-file=/var/run/utmp \
		--with-wtmp-file=/var/log/wtmp \
		--with-xdmconfigdir='$${sysconfdir}/X11/xdm' \
		--with-xdmscriptdir='$${libexecdir}/X11/xdm' \
		--with-xft \
		\
		--disable-strict-compilation \
		--without-pam \
		--without-selinux

build-xdm-rule:
	$(MAKE) -C $(xdm) all

install-xdm-rule: $(call installed,libXaw libXft libXinerama sessreg xinit xrdb)
	$(MAKE) -C $(xdm) install
