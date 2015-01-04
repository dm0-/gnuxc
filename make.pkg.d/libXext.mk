libXext                 := libXext-1.3.3
libXext_url             := http://xorg.freedesktop.org/releases/individual/lib/$(libXext).tar.bz2

configure-libXext-rule:
	cd $(libXext) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXext-rule:
	$(MAKE) -C $(libXext) all

install-libXext-rule: $(call installed,libX11)
	$(MAKE) -C $(libXext) install
