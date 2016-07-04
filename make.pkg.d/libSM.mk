libSM                   := libSM-1.2.2
libSM_sha1              := e6d5dab6828dfd296e564518d2ed0a349a25a714
libSM_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libSM).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport \
		--with-libuuid

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,e2fsprogs libICE)
	$(MAKE) -C $(builddir) install
