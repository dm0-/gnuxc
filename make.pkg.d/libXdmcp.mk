libXdmcp                := libXdmcp-1.1.2
libXdmcp_key            := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
libXdmcp_url            := http://xorg.freedesktop.org/releases/individual/lib/$(libXdmcp).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
