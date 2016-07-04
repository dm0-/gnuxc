inputproto              := inputproto-2.3.2
inputproto_sha1         := 62b29a0c3b4ede9d129a0598cc6becf628a2158a
inputproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(inputproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/inputproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
