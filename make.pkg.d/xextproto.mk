xextproto               := xextproto-7.3.0
xextproto_sha1          := b8d736342dcb73b71584d99a1cb9806d93c25ff8
xextproto_url           := http://xorg.freedesktop.org/releases/individual/proto/$(xextproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/xextproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
