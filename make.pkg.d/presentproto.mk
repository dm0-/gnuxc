presentproto            := presentproto-1.1
presentproto_key        := 7B27A3F1A6E18CD9588B4AE8310180050905E40C
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
