libXpm                  := libXpm-3.5.12
libXpm_sha1             := 4e22fefe61714209539b08051b5287bcd9ecfd04
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
