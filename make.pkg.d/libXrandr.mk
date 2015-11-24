libXrandr               := libXrandr-1.5.0
libXrandr_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXrandr).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXext libXrender randrproto)
	$(MAKE) -C $(builddir) install
