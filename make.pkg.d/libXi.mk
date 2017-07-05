libXi                   := libXi-1.7.9
libXi_sha1              := 70d1148c39c0eaa7d7c18370f20709383271f669
libXi_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libXi).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,inputproto libXext libXfixes)
	$(MAKE) -C $(builddir) install
