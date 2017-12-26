libfontenc              := libfontenc-1.1.3
libfontenc_key          := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
libfontenc_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libfontenc).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install
