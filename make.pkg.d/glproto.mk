glproto                 := glproto-1.4.17
glproto_sha1            := 20e061c463bed415051f0f89e968e331a2078551
glproto_url             := http://xorg.freedesktop.org/releases/individual/proto/$(glproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/glproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
