xdm                     := xdm-1.1.11
xdm_url                 := http://xorg.freedesktop.org/releases/individual/app/$(xdm).tar.bz2

$(prepare-rule):
	$(call apply,empty-shadow-pass)
	$(DOWNLOAD) 'http://cgit.freedesktop.org/xorg/app/xdm/patch/?id='8d1eb5c74413e4c9a21f689fc106949b121c0117 | $(PATCH) -d $(builddir) -F1 -p1

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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
		--with-bw-pixmap=login-logo-bw.xpm \
		--with-color-pixmap=login-logo.xpm \
		--with-piddir=/run \
		--with-pixmapdir=/usr/share/pixmaps \
		--with-random-device=/dev/urandom \
		--with-utmp-file=/run/utmp \
		--with-wtmp-file=/var/log/wtmp \
		--with-xdmconfigdir='$${sysconfdir}/X11/xdm' \
		--with-xdmscriptdir='$${libexecdir}/X11/xdm' \
		--with-xft \
		\
		--disable-secure-rpc \
		--disable-strict-compilation \
		--without-pam \
		--without-selinux

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXaw libXft libXinerama sessreg xinit xrdb)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,dmd.scm) $(DESTDIR)/etc/dmd.d/xdm.scm
# Use the Xorg logos by default if there aren't any logos already.
	test -e $(DESTDIR)/usr/share/pixmaps/login-logo.xpm || $(SYMLINK) xorg.xpm $(DESTDIR)/usr/share/pixmaps/login-logo.xpm
	test -e $(DESTDIR)/usr/share/pixmaps/login-logo-bw.xpm || $(SYMLINK) xorg-bw.xpm $(DESTDIR)/usr/share/pixmaps/login-logo-bw.xpm

# Write inline files.
$(call addon-file,dmd.scm): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,dmd.scm)


# Provide a system service definition for "xdm".
override define contents
(define xdm-command
  '("/usr/bin/xdm"
    "-nodaemon"))
(make <service>
  #:docstring "The xdm service presents the graphical login screen."
  #:provides '(xdm)
  #:requires '(console)
  #:start (make-forkexec-constructor xdm-command)
  #:stop (make-kill-destructor))
endef
$(call addon-file,dmd.scm): private override contents := $(value contents)
