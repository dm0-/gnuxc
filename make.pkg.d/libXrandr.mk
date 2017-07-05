libXrandr               := libXrandr-1.5.1
libXrandr_sha1          := 7232fe2648b96fed531208c3ad2ba0be61990041
libXrandr_url           := http://xorg.freedesktop.org/releases/individual/lib/$(libXrandr).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXext libXrender randrproto)
	$(MAKE) -C $(builddir) install
