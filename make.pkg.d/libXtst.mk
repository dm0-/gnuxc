libXtst                 := libXtst-1.2.3
libXtst_key             := C41C985FDCF1E5364576638B687393EE37D128F8
libXtst_url             := http://xorg.freedesktop.org/releases/individual/lib/$(libXtst).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXi recordproto)
	$(MAKE) -C $(builddir) install
