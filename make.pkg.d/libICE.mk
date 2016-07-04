libICE                  := libICE-1.0.9
libICE_sha1             := 3c3a857a117ce48a1947a16860056e77cd494fdf
libICE_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libICE).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-ipv6 \
		--enable-local-transport \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-tcp-transport \
		--enable-unix-transport

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xtrans)
	$(MAKE) -C $(builddir) install
