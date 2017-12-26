libXfont2               := libXfont2-2.0.3
libXfont2_key           := C41C985FDCF1E5364576638B687393EE37D128F8
libXfont2_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXfont2).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-{bdf,pcf,snf}format \
		--enable-builtins \
		--enable-devel-docs \
		--enable-fc \
		--enable-freetype \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport \
		--with-bzip2

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,fontsproto freetype libfontenc xtrans)
	$(MAKE) -C $(builddir) install
