sessreg                 := sessreg-1.1.1
sessreg_key             := 3BB639E56F861FA2E86505690FDD682D974CA72A
sessreg_url             := http://xorg.freedesktop.org/releases/individual/app/$(sessreg).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		CPPFLAGS=-P

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
