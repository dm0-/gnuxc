xtrans                  := xtrans-1.3.5
xtrans_sha1             := 2d3ae1839d841f568bc481c6116af7d2a9f9ba59
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
