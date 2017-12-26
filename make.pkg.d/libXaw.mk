libXaw                  := libXaw-1.0.13
libXaw_key              := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
libXaw_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXaw).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xaw{6,7}

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXmu libXpm)
	$(MAKE) -C $(builddir) install
