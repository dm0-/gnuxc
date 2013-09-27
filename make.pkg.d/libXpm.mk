libXpm                  := libXpm-3.5.11
libXpm_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXpm).tar.bz2

configure-libXpm-rule:
	cd $(libXpm) && ./$(configure) \
		--disable-silent-rules \
		--enable-stat-zfile \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXpm-rule:
	$(MAKE) -C $(libXpm) all

install-libXpm-rule: $(call installed,libXt)
	$(MAKE) -C $(libXpm) install
