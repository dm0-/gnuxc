libXfixes               := libXfixes-5.0.1
libXfixes_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXfixes).tar.bz2

configure-libXfixes-rule:
	cd $(libXfixes) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXfixes-rule:
	$(MAKE) -C $(libXfixes) all

install-libXfixes-rule: $(call installed,fixesproto libX11)
	$(MAKE) -C $(libXfixes) install
