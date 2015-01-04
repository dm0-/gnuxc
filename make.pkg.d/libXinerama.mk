libXinerama             := libXinerama-1.1.3
libXinerama_url         := http://xorg.freedesktop.org/releases/individual/lib/$(libXinerama).tar.bz2

configure-libXinerama-rule:
	cd $(libXinerama) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXinerama-rule:
	$(MAKE) -C $(libXinerama) all

install-libXinerama-rule: $(call installed,libXext xineramaproto)
	$(MAKE) -C $(libXinerama) install
