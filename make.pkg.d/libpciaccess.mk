libpciaccess            := libpciaccess-0.13.5
libpciaccess_sha1       := ea98c13623e218359ca6d9af9ab9aa4780201a5b
libpciaccess_url        := http://xorg.freedesktop.org/releases/individual/lib/$(libpciaccess).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-zlib

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,pciutils)
	$(MAKE) -C $(builddir) install
