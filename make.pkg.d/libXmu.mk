libXmu                  := libXmu-1.1.2
libXmu_sha1             := 7e6aeef726743d21aa272c424e7d7996e92599eb
libXmu_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXmu).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXext libXt)
	$(MAKE) -C $(builddir) install
