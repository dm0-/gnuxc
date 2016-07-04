videoproto              := videoproto-2.3.3
videoproto_sha1         := 4556b5c2243a2ca290ea2140dc1a427c4bac8ba2
videoproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(videoproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/videoproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
