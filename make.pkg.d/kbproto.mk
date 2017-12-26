kbproto                 := kbproto-1.0.7
kbproto_key             := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
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
