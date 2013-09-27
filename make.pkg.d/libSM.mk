libSM                   := libSM-1.2.2
libSM_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libSM).tar.bz2

configure-libSM-rule:
	cd $(libSM) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport \
		--with-libuuid

build-libSM-rule:
	$(MAKE) -C $(libSM) all

install-libSM-rule: $(call installed,e2fsprogs libICE)
	$(MAKE) -C $(libSM) install
