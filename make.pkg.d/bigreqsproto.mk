bigreqsproto            := bigreqsproto-1.1.2
bigreqsproto_sha1       := ef1765eeb5e9e38d080225fe6a64ed7cd2984b46
bigreqsproto_url        := http://xorg.freedesktop.org/releases/individual/proto/$(bigreqsproto).tar.bz2

$(prepare-rule):
# Installed headers use types defined in xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/bigreqsproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
