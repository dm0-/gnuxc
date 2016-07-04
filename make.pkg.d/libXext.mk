libXext                 := libXext-1.3.3
libXext_sha1            := 43abab84101159563e68d9923353cc0b3af44f07
libXext_url             := http://xorg.freedesktop.org/releases/individual/lib/$(libXext).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libX11)
	$(MAKE) -C $(builddir) install
