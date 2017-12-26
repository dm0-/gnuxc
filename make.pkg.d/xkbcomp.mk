xkbcomp                 := xkbcomp-1.4.0
xkbcomp_key             := A66D805F7C9329B4C5D82767CCC4F07FAC641EFF
xkbcomp_url             := http://xorg.freedesktop.org/releases/individual/app/$(xkbcomp).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libxkbfile)
	$(MAKE) -C $(builddir) install
