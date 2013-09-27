libXrender              := libXrender-0.9.8
libXrender_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libXrender).tar.bz2

configure-libXrender-rule:
	cd $(libXrender) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXrender-rule:
	$(MAKE) -C $(libXrender) all

install-libXrender-rule: $(call installed,libX11 renderproto)
	$(MAKE) -C $(libXrender) install
