libX11                  := libX11-1.6.2
libX11_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libX11).tar.bz2

prepare-libX11-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(libX11)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(libX11)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(libX11)/configure

configure-libX11-rule:
	cd $(libX11) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-loadable-i18n \
		--enable-loadable-xcursor \
		--enable-local-transport \
		--enable-secure-rpc \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport \
		--enable-xlocaledir \
		--enable-xthreads \
		--with-perl

build-libX11-rule:
	$(MAKE) -C $(libX11) all

install-libX11-rule: $(call installed,inputproto kbproto libxcb xextproto xtrans)
	$(MAKE) -C $(libX11) install
