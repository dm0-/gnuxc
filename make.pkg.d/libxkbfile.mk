libxkbfile              := libxkbfile-1.0.8
libxkbfile_url          := http://xorg.freedesktop.org/releases/individual/lib/$(libxkbfile).tar.bz2

configure-libxkbfile-rule:
	cd $(libxkbfile) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libxkbfile-rule:
	$(MAKE) -C $(libxkbfile) all

install-libxkbfile-rule: $(call installed,libX11)
	$(MAKE) -C $(libxkbfile) install
