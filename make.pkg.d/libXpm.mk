libXpm                  := libXpm-3.5.12
libXpm_key              := C41C985FDCF1E5364576638B687393EE37D128F8
libXpm_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXpm).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-stat-zfile \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXt)
	$(MAKE) -C $(builddir) install
