randrproto              := randrproto-1.5.0
randrproto_key          := 10A6D91DA1B05BD29F6DEBAC0C74F35979C486BE
randrproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(randrproto).tar.bz2

$(prepare-rule):
# Installed headers include renderproto headers.
	$(ECHO) 'Requires: renderproto' >> $(builddir)/randrproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,renderproto)
	$(MAKE) -C $(builddir) install
