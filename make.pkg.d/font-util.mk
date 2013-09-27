font-util               := font-util-1.3.0
font-util_url           := http://xorg.freedesktop.org/releases/individual/font/$(font-util).tar.bz2

configure-font-util-rule:
	cd $(font-util) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation \
		--with-fontrootdir='$${datadir}/X11/fonts'

build-font-util-rule:
	$(MAKE) -C $(font-util) all

install-font-util-rule: $(call installed,glibc)
	$(MAKE) -C $(font-util) install
