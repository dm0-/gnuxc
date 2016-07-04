libpciaccess            := libpciaccess-0.13.4
libpciaccess_sha1       := 99e791fe20924b9da29bf7c7ed9438739c4f2930
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
