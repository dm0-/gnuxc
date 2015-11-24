xkbcomp                 := xkbcomp-1.3.1
xkbcomp_url             := http://xorg.freedesktop.org/releases/individual/app/$(xkbcomp).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libxkbfile)
	$(MAKE) -C $(builddir) install
