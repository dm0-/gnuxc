libXinerama             := libXinerama-1.1.3
libXinerama_sha1        := 6a3956d73f7457ef0b4db12806d99c6918e328e3
libXinerama_url         := http://xorg.freedesktop.org/releases/individual/lib/$(libXinerama).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXext xineramaproto)
	$(MAKE) -C $(builddir) install
