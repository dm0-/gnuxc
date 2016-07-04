fontsproto              := fontsproto-2.1.3
fontsproto_sha1         := 28c108bd6438c332122c10871c1fc6415591755f
fontsproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(fontsproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/fontsproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
