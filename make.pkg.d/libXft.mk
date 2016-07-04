libXft                  := libXft-2.3.2
libXft_sha1             := e025d790a7b6c4d283a78d8df06615cb10278e2d
libXft_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXft).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,fontconfig libXrender)
	$(MAKE) -C $(builddir) install
