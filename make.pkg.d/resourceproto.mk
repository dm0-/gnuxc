resourceproto           := resourceproto-1.2.0
resourceproto_sha1      := 9ff9bb9243b0474330959dc3853973523c9dd9ce
resourceproto_url       := http://xorg.freedesktop.org/releases/individual/proto/$(resourceproto).tar.bz2

$(prepare-rule):
# Installed headers use types defined in xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/resourceproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
