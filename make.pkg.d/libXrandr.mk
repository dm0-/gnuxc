libXrandr               := libXrandr-1.4.2
libXrandr_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXrandr).tar.bz2

configure-libXrandr-rule:
	cd $(libXrandr) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXrandr-rule:
	$(MAKE) -C $(libXrandr) all

install-libXrandr-rule: $(call installed,libXext libXrender randrproto)
	$(MAKE) -C $(libXrandr) install
