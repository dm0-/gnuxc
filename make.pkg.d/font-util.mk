font-util               := font-util-1.3.1
font-util_sha1          := 0b16add3637c64b0bbaf1dd223b71b0421100c20
font-util_url           := http://xorg.freedesktop.org/releases/individual/font/$(font-util).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation \
		--with-fontrootdir='$${datadir}/X11/fonts'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
