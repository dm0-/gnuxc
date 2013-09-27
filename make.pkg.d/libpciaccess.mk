libpciaccess            := libpciaccess-0.13.2
libpciaccess_url        := http://xorg.freedesktop.org/releases/individual/lib/$(libpciaccess).tar.bz2

configure-libpciaccess-rule:
	cd $(libpciaccess) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-zlib

build-libpciaccess-rule:
	$(MAKE) -C $(libpciaccess) all

install-libpciaccess-rule: $(call installed,pciutils)
	$(MAKE) -C $(libpciaccess) install
