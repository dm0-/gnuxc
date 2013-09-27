libXau                  := libXau-1.0.8
libXau_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXau).tar.bz2

configure-libXau-rule:
	cd $(libXau) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation \
		--enable-xthreads

build-libXau-rule:
	$(MAKE) -C $(libXau) all

install-libXau-rule: $(call installed,xproto)
	$(MAKE) -C $(libXau) install
