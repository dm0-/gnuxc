xineramaproto           := xineramaproto-1.2.1
xineramaproto_url       := http://xorg.freedesktop.org/releases/individual/proto/$(xineramaproto).tar.bz2

configure-xineramaproto-rule:
	cd $(xineramaproto) && ./$(configure) \
		--enable-strict-compilation

build-xineramaproto-rule:
	$(MAKE) -C $(xineramaproto) all

install-xineramaproto-rule: $(call installed,xextproto)
	$(MAKE) -C $(xineramaproto) install
