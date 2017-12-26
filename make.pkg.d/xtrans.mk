xtrans                  := xtrans-1.3.5
xtrans_key              := C383B778255613DFDB409D91DB221A6900000011
xtrans_url              := http://xorg.freedesktop.org/releases/individual/lib/$(xtrans).tar.bz2

$(prepare-rule):
# Installed headers include xproto headers.
	$(ECHO) 'Requires: xproto' >> $(builddir)/xtrans.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
