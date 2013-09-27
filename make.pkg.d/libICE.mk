libICE                  := libICE-1.0.8
libICE_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libICE).tar.bz2

configure-libICE-rule:
	cd $(libICE) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport

build-libICE-rule:
	$(MAKE) -C $(libICE) all

install-libICE-rule: $(call installed,xtrans)
	$(MAKE) -C $(libICE) install
