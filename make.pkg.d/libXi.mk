libXi                   := libXi-1.7.9
libXi_key               := 3C2C43D9447D5938EF4551EBE23B7E70B467F0BF
libXi_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libXi).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,inputproto libXext libXfixes)
	$(MAKE) -C $(builddir) install
