libXdmcp                := libXdmcp-1.1.2
libXdmcp_sha1           := 3c09eabb0617c275b5ab09fae021d279a4832cac
libXdmcp_url            := http://xorg.freedesktop.org/releases/individual/lib/$(libXdmcp).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xproto)
	$(MAKE) -C $(builddir) install
