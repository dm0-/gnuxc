emacs                   := emacs-25.2
emacs_sha1              := 3960d0b64031c645d98aafd4dc9ebf6f6ef4cf50
emacs_url               := http://ftpmirror.gnu.org/emacs/$(emacs).tar.xz

$(prepare-rule):
	$(call apply,update-ImageMagick)

ifeq ($(host),$(build))
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-acl \
		--enable-check-lisp-object-type \
		--enable-checking=all \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-gtk-deprecation-warnings \
		--enable-link-time-optimization \
		--without-all \
		--with-cairo \
		--with-gameuser=nobody \
		--with-gif \
		--with-gnutls \
		--with-imagemagick \
		--with-jpeg \
		--with-makeinfo \
		--with-modules \
		--with-png \
		--with-rsvg \
		--with-sound=oss \
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
		--disable-link-time-optimization \
		--without-compress-install \
		--without-dbus \
		--without-gconf \
		--without-gpm \
		--without-gsettings \
		--without-selinux \
		--without-sound

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,giflib gnutls gtk2 ImageMagick libXinerama)
	$(MAKE) -C $(builddir) install
else
$(install-rule):
	$(INSTALL) -Dm 664 /dev/null $(DESTDIR)/var/games/emacs/snake-scores
	$(INSTALL) -Dm 664 /dev/null $(DESTDIR)/var/games/emacs/tetris-scores
endif
	$(INSTALL) -Dpm 644 $(call addon-file,site-start.el) $(DESTDIR)/usr/share/emacs/site-lisp/site-start.el
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/emacs/site-lisp/site-start.d
	$(INSTALL) -Dpm 644 $(call addon-file,emacs-user.el) $(DESTDIR)/etc/skel/.emacs
	$(INSTALL) -dm 755 $(DESTDIR)/etc/skel/.local/share/emacs/backups

# Write inline files.
$(call addon-file,emacs-user.el site-start.el): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,emacs-user.el site-start.el)


# Provide a site-wide auto-run directory like on Fedora.
override define contents
(mapc 'load
 (delete-dups
  (mapcar 'file-name-sans-extension
   (directory-files
    "/usr/share/emacs/site-lisp/site-start.d" t "\\.elc?\\'"))))
(setq source-directory "/usr/share/$(subst -,/,$(emacs))/")
endef
$(call addon-file,site-start.el): private override contents := $(contents)


# Provide default user settings for Emacs.
override define contents
(require 'emms-setup "emms-setup" t)
(setq backup-directory-alist '((".*" . "~/.local/share/emacs/backups")))
(column-number-mode 1)
(electric-indent-mode 0)
(setq-default indent-tabs-mode nil)
(unless (display-graphic-p) (menu-bar-mode 0))
(if (cdr command-line-args) (setq inhibit-startup-screen t))
endef
$(call addon-file,emacs-user.el): private override contents := $(value contents)
