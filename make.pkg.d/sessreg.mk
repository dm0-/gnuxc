sessreg                 := sessreg-1.0.8
sessreg_url             := http://xorg.freedesktop.org/releases/individual/app/$(sessreg).tar.bz2

configure-sessreg-rule:
	cd $(sessreg) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-sessreg-rule:
	$(MAKE) -C $(sessreg) all

install-sessreg-rule: $(call installed,glibc)
	$(MAKE) -C $(sessreg) install
