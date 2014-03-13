libXft                  := libXft-2.3.1
libXft_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXft).tar.bz2

prepare-libXft-rule:
	$(PATCH) -d $(libXft) -p1 < $(patchdir)/$(libXft)-freetype-update.patch

configure-libXft-rule:
	cd $(libXft) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

build-libXft-rule:
	$(MAKE) -C $(libXft) all

install-libXft-rule: $(call installed,fontconfig libXrender)
	$(MAKE) -C $(libXft) install
