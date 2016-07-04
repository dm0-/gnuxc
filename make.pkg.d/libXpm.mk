libXpm                  := libXpm-3.5.11
libXpm_sha1             := 77b95dd1c8cd9bc00b3b834b53d824409202acbb
libXpm_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXpm).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-stat-zfile \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXt)
	$(MAKE) -C $(builddir) install
