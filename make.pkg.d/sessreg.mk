sessreg                 := sessreg-1.1.1
sessreg_sha1            := 09437d9da0b88acde6ca67e231870899023cc3d2
sessreg_url             := http://xorg.freedesktop.org/releases/individual/app/$(sessreg).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		CPPFLAGS=-P

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
