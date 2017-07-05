libXfont2               := libXfont2-2.0.1
libXfont2_sha1          := 4cf056ab00bf631649e040051cf8e2b096cc245b
libXfont2_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXfont2).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
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
