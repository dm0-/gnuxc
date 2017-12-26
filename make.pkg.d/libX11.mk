libX11                  := libX11-1.6.5
libX11_key              := 3BB639E56F861FA2E86505690FDD682D974CA72A
libX11_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libX11).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-ipv6 \
		--enable-loadable-i18n \
		--enable-loadable-xcursor \
		--enable-local-transport \
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
