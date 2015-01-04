xkbcomp                 := xkbcomp-1.3.0
xkbcomp_url             := http://xorg.freedesktop.org/releases/individual/app/$(xkbcomp).tar.bz2

configure-xkbcomp-rule:
	cd $(xkbcomp) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-xkbcomp-rule:
	$(MAKE) -C $(xkbcomp) all

install-xkbcomp-rule: $(call installed,libxkbfile)
	$(MAKE) -C $(xkbcomp) install
