xproto                  := xproto-7.0.31
xproto_key              := C383B778255613DFDB409D91DB221A6900000011
xproto_url              := http://xorg.freedesktop.org/releases/individual/proto/$(xproto).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-const-prototypes \
		--enable-function-prototypes \
		--enable-nested-prototypes \
		--enable-strict-compilation \
		--enable-varargs-prototypes \
		--enable-wide-prototypes

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
