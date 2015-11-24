emacs                   := emacs-24.5
emacs_url               := http://ftpmirror.gnu.org/emacs/$(emacs).tar.xz

ifeq ($(host),$(build))
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-acl \
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
		--disable-autodepend \
		--disable-checking \
		--without-compress-install \
		--without-dbus \
		--without-gconf \
		--without-gpm \
		--without-gsettings \
		--without-selinux \
		--without-sound

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,giflib gnutls libjpeg-turbo libpng librsvg libXaw libXinerama tiff)
	$(MAKE) -C $(builddir) install
else
$(install-rule):
endif
	$(INSTALL) -Dpm 644 $(call addon-file,emacs-user) $(DESTDIR)/etc/skel/.emacs
	$(INSTALL) -dm 755 $(DESTDIR)/etc/skel/.local/share/emacs/backups

# Write inline files.
$(call addon-file,emacs-user): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,emacs-user)


# Provide default user settings for Emacs.
override define contents
(setq backup-directory-alist '((".*" . "~/.local/share/emacs/backups")))
(column-number-mode 1)
(electric-indent-mode 0)
(unless (display-graphic-p) (menu-bar-mode 0))
endef
$(call addon-file,emacs-user): private override contents := $(value contents)
