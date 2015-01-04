emacs                   := emacs-24.4
emacs_url               := http://ftpmirror.gnu.org/emacs/$(emacs).tar.xz

ifeq ($(host),$(build))
configure-emacs-rule:
	cd $(emacs) && ./$(configure) \
		--enable-acl \
		--enable-autodepend \
		--enable-checking=all \
		--enable-check-lisp-object-type \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-link-time-optimization \
		--without-all \
		--with-gameuser=nobody \
		--with-gif \
		--with-gnutls \
		--with-jpeg \
		--with-makeinfo \
		--with-pkg-config-prog=$(firstword $(PKG_CONFIG)) \
		--with-png \
		--with-rsvg \
		--with-tiff \
		--with-wide-int \
		--with-x \
		--with-x-toolkit=gtk2 --with-toolkit-scroll-bars \
		--with-xft \
		--with-xim \
		--with-xml2 \
		--with-xpm \
		--with-zlib \
		\
		--disable-checking \
		--without-compress-install \
		--without-dbus \
		--without-gconf \
		--without-gpm \
		--without-gsettings \
		--without-selinux \
		--without-sound

build-emacs-rule:
	$(MAKE) -C $(emacs) all

install-emacs-rule: $(call installed,giflib gnutls libjpeg-turbo libpng librsvg libXaw libXinerama tiff)
	$(MAKE) -C $(emacs) install
else
install-emacs-rule:
endif
	$(INSTALL) -Dpm 644 $(emacs)/emacs-user $(DESTDIR)/etc/skel/.emacs
	$(INSTALL) -dm 755 $(DESTDIR)/etc/skel/.local/share/emacs/backups

# Provide default user settings for Emacs.
$(emacs)/emacs-user: | $(emacs)
	$(ECHO) '(setq backup-directory-alist '"'"'((".*" . "~/.local/share/emacs/backups")))' > $@
	$(ECHO) '(column-number-mode 1)' >> $@
	$(ECHO) '(unless (display-graphic-p) (menu-bar-mode 0))' >> $@
$(call prepared,emacs): $(emacs)/emacs-user
