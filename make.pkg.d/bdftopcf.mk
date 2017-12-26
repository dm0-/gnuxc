bdftopcf                := bdftopcf-1.1
bdftopcf_key            := 995ED5C8A6138EB0961F18474C09DD83CAAA50B2
bdftopcf_url            := http://xorg.freedesktop.org/releases/individual/app/$(bdftopcf).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
