xcmiscproto             := xcmiscproto-1.2.2
xcmiscproto_sha1        := 59ae9ec6414964440bf654b207618e5dd66a32fb
xcmiscproto_url         := http://xorg.freedesktop.org/releases/individual/proto/$(xcmiscproto).tar.bz2

$(prepare-rule):
# Installed headers use types defined in xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/xcmiscproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
