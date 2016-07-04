presentproto            := presentproto-1.0
presentproto_sha1       := 432371cdc464881029c3f39f9bf81cc80a484e54
presentproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(presentproto).tar.bz2

$(prepare-rule):
# Installed headers use types defined in xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/presentproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
