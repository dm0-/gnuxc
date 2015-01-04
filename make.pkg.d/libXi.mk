libXi                   := libXi-1.7.4
libXi_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libXi).tar.bz2

configure-libXi-rule:
	cd $(libXi) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXi-rule:
	$(MAKE) -C $(libXi) all

install-libXi-rule: $(call installed,inputproto libXext libXfixes)
	$(MAKE) -C $(libXi) install
