videoproto              := videoproto-2.3.3
videoproto_key          := DD38563A8A8224537D1F90E45B8A2D50A0ECD0D3
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
