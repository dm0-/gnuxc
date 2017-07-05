libXfixes               := libXfixes-5.0.3
libXfixes_sha1          := ca86342d129c02435a9ee46e38fdf1a04d6b4b91
libXfixes_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXfixes).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,fixesproto libX11)
	$(MAKE) -C $(builddir) install
