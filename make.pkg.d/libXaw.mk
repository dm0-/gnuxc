libXaw                  := libXaw-1.0.12
libXaw_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXaw).tar.bz2

configure-libXaw-rule:
	cd $(libXaw) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xaw{6,7}

build-libXaw-rule:
	$(MAKE) -C $(libXaw) all

install-libXaw-rule: $(call installed,libXmu libXpm)
	$(MAKE) -C $(libXaw) install
