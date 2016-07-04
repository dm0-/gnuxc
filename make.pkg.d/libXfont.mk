libXfont                := libXfont-1.5.1
libXfont_sha1           := e63a354de5dc2d8cba08d50add1519471412a618
libXfont_url            := http://xorg.freedesktop.org/releases/individual/lib/$(libXfont).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-{bdf,pcf,snf}format \
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
