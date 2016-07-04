libXfixes               := libXfixes-5.0.2
libXfixes_sha1          := 56ad5e27f2cb7dcc61af4bab813464415ff0b25b
libXfixes_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXfixes).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,fixesproto libX11)
	$(MAKE) -C $(builddir) install
