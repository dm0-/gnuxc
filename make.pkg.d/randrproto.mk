randrproto              := randrproto-1.5.0
randrproto_sha1         := bc420745dc4af011988e9dcabdadf8829cbc2374
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
