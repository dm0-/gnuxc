libXt                   := libXt-1.1.4
libXt_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libXt).tar.bz2

prepare-libXt-rule:
	$(EDIT) '/^app/{s,@appdefaultdir@,$${datarootdir}/X11/app-defaults,g;N;s/\(.*\)\n\(.*\)/\2\n\1/}' $(libXt)/xt.pc.in

configure-libXt-rule:
	cd $(libXt) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xkb \
		--with-glib \
		--with-perl

build-libXt-rule:
	$(MAKE) -C $(libXt) all

install-libXt-rule: $(call installed,libSM libX11)
	$(MAKE) -C $(libXt) install
