libfontenc              := libfontenc-1.1.3
libfontenc_sha1         := 312116f5156d6a8a2404c59560b60d53ddf1a09f
libfontenc_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libfontenc).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install
