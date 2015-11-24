pixman                  := pixman-0.33.4
pixman_url              := http://xorg.freedesktop.org/releases/individual/lib/$(pixman).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-libpng \
		--enable-timers

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libpng)
	$(MAKE) -C $(builddir) install
