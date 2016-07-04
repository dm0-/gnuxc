xf86dgaproto            := xf86dgaproto-2.1
xf86dgaproto_sha1       := 97a06120e7195c968875e8ba42e82c90ab54948b
xf86dgaproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(xf86dgaproto).tar.bz2

$(prepare-rule):
# Installed headers use types defined in xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/xf86dgaproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
