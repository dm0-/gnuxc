libfontenc              := libfontenc-1.1.2
libfontenc_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libfontenc).tar.bz2

configure-libfontenc-rule:
	cd $(libfontenc) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libfontenc-rule:
	$(MAKE) -C $(libfontenc) all

install-libfontenc-rule: $(call installed,zlib)
	$(MAKE) -C $(libfontenc) install
