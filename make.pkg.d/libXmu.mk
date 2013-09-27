libXmu                  := libXmu-1.1.2
libXmu_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXmu).tar.bz2

configure-libXmu-rule:
	cd $(libXmu) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport

build-libXmu-rule:
	$(MAKE) -C $(libXmu) all

install-libXmu-rule: $(call installed,libXext libXt)
	$(MAKE) -C $(libXmu) install
