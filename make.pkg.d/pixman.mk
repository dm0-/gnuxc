pixman                  := pixman-0.32.4
pixman_url              := http://xorg.freedesktop.org/releases/individual/lib/$(pixman).tar.bz2

configure-pixman-rule:
	cd $(pixman) && ./$(configure) \
		--disable-silent-rules \
		--enable-libpng

build-pixman-rule:
	$(MAKE) -C $(pixman) all

install-pixman-rule: $(call installed,libpng)
	$(MAKE) -C $(pixman) install
