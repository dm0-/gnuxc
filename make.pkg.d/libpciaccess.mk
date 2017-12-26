libpciaccess            := libpciaccess-0.14
libpciaccess_key        := 995ED5C8A6138EB0961F18474C09DD83CAAA50B2
libpciaccess_url        := http://xorg.freedesktop.org/releases/individual/lib/$(libpciaccess).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-zlib

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,pciutils)
	$(MAKE) -C $(builddir) install
