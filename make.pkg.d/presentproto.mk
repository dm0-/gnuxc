presentproto            := presentproto-1.1
presentproto_sha1       := b1294dbb3a8337f79252142b45aa123ee1aa7602
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
