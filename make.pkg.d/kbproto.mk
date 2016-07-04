kbproto                 := kbproto-1.0.7
kbproto_sha1            := bc9c0fa7d39edf4ac043e6eeaa771d3e245ac5b2
kbproto_url             := http://xorg.freedesktop.org/releases/individual/proto/$(kbproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/kbproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
