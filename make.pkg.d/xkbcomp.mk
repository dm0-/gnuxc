xkbcomp                 := xkbcomp-1.4.0
xkbcomp_sha1            := 9578a564ff8fcf96581fb52860828fbab8c67b4f
xkbcomp_url             := http://xorg.freedesktop.org/releases/individual/app/$(xkbcomp).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libxkbfile)
	$(MAKE) -C $(builddir) install
