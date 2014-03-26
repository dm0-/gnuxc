emacs                   := emacs-24.3
emacs_url               := http://ftp.gnu.org/gnu/emacs/$(emacs).tar.xz

prepare-emacs-rule:
	$(EDIT) 's/.*BSD_SYSTEM 43.*/:/' $(emacs)/configure

ifeq ($(host),$(build))
configure-emacs-rule:
	cd $(emacs) && ./$(configure) \
		--enable-autodepend \
		--enable-checking=all \
		--enable-check-lisp-object-type \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--without-all \
		--with-compress-info \
		--with-gnutls \
		--with-jpeg \
		--with-makeinfo \
		--with-pkg-config-prog=$(firstword $(PKG_CONFIG)) \
		--with-png \
		--with-rsvg \
		--with-tiff \
		--with-wide-int \
		--with-x \
		--with-x-toolkit=athena --with-toolkit-scroll-bars \
		--with-xft \
		--with-xml2 \
		--with-xpm \
		\
		--without-dbus \
		--without-gconf \
		--without-gpm \
		--without-gsettings \
		--without-selinux \
		--without-sound
#		--enable-link-time-optimization # lto-wrapper dies on native

build-emacs-rule:
	$(MAKE) -C $(emacs) all

install-emacs-rule: $(call installed,gnutls libjpeg-turbo libpng librsvg libXaw tiff)
	$(MAKE) -C $(emacs) install
endif
