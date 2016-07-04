damageproto             := damageproto-1.2.1
damageproto_sha1        := bd0f0f4dc8f37eaabd9279d10fe2889710507358
damageproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(damageproto).tar.bz2

$(prepare-rule):
# Installed headers include fixesproto headers.
	$(ECHO) 'Requires: fixesproto' >> $(builddir)/damageproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,fixesproto)
	$(MAKE) -C $(builddir) install
