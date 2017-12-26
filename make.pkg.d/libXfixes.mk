libXfixes               := libXfixes-5.0.3
libXfixes_key           := C41C985FDCF1E5364576638B687393EE37D128F8
libXfixes_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXfixes).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,fixesproto libX11)
	$(MAKE) -C $(builddir) install
