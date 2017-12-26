pixman                  := pixman-0.34.0
pixman_sha1             := 367698744e74d6d4f363041482965b9ea7fbe4a5
pixman_url              := http://xorg.freedesktop.org/releases/individual/lib/$(pixman).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-openmp \
		--enable-timers \
		\
		--disable-{gtk,libpng} # These are only for testing.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
