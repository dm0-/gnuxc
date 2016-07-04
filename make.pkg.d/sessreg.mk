sessreg                 := sessreg-1.1.0
sessreg_sha1            := a27a476f7f39ae30a16dfa25ca07c12378cff7f0
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
