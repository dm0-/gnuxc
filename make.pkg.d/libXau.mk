libXau                  := libXau-1.0.8
libXau_sha1             := d9512d6869e022d4e9c9d33f6d6199eda4ad096b
libXau_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXau).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xthreads

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
