libXdmcp                := libXdmcp-1.1.1
libXdmcp_url            := http://xorg.freedesktop.org/releases/individual/lib/$(libXdmcp).tar.bz2

configure-libXdmcp-rule:
	cd $(libXdmcp) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

build-libXdmcp-rule:
	$(MAKE) -C $(libXdmcp) all

install-libXdmcp-rule: $(call installed,xproto)
	$(MAKE) -C $(libXdmcp) install
