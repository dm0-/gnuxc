xinit                   := xinit-1.3.4
xinit_url               := http://xorg.freedesktop.org/releases/individual/app/$(xinit).tar.bz2

prepare-xinit-rule:
# Fix the VT argument.
	$(EDIT) 's/vt\$$/tty$$/' $(xinit)/startx.cpp

configure-xinit-rule:
	cd $(xinit) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-xinitdir='$${sysconfdir}/X11/xinit'

build-xinit-rule:
	$(MAKE) -C $(xinit) all

install-xinit-rule: $(call installed,xauth xorg-server)
	$(MAKE) -C $(xinit) install
