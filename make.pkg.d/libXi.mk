libXi                   := libXi-1.7.5
libXi_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libXi).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,inputproto libXext libXfixes)
	$(MAKE) -C $(builddir) install
