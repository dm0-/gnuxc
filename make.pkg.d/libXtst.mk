libXtst                 := libXtst-1.2.3
libXtst_sha1            := 27d004db631bee3a82155d3caf961d9584207d36
libXtst_url             := http://xorg.freedesktop.org/releases/individual/lib/$(libXtst).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXi recordproto)
	$(MAKE) -C $(builddir) install
