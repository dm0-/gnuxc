renderproto             := renderproto-0.11.1
renderproto_sha1        := 7ae9868a358859fe539482b02414aa15c2d8b1e4
renderproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(renderproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/renderproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
