xproto                  := xproto-7.0.31
xproto_sha1             := 779fa333c5522cca40ca810c25a8fa60b6ccedfb
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
