font-util               := font-util-1.3.1
font-util_key           := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
font-util_url           := http://xorg.freedesktop.org/releases/individual/font/$(font-util).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation \
		--with-fontrootdir='$${datadir}/X11/fonts'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
