xproto                  := xproto-7.0.29
xproto_sha1             := e2ea1d12235bfcd83dbc815fb69524ef0be5c1fb
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
