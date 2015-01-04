xproto                  := xproto-7.0.27
xproto_url              := http://xorg.freedesktop.org/releases/individual/proto/$(xproto).tar.bz2

configure-xproto-rule:
	cd $(xproto) && ./$(configure) \
		--enable-const-prototypes \
		--enable-function-prototypes \
		--enable-nested-prototypes \
		--enable-strict-compilation \
		--enable-varargs-prototypes \
		--enable-wide-prototypes

build-xproto-rule:
	$(MAKE) -C $(xproto) all

install-xproto-rule: $(call installed,glibc)
	$(MAKE) -C $(xproto) install
