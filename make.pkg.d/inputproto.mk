inputproto              := inputproto-2.3.2
inputproto_key          := 3C2C43D9447D5938EF4551EBE23B7E70B467F0BF
inputproto_url          := http://xorg.freedesktop.org/releases/individual/proto/$(inputproto).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/inputproto.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
