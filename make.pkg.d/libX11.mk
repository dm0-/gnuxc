libX11                  := libX11-1.6.3
libX11_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libX11).tar.bz2

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,inputproto kbproto libxcb xextproto xtrans)
	$(MAKE) -C $(builddir) install
