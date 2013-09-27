bdftopcf                := bdftopcf-1.0.4
bdftopcf_url            := http://xorg.freedesktop.org/releases/individual/app/$(bdftopcf).tar.bz2

configure-bdftopcf-rule:
	cd $(bdftopcf) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation

build-bdftopcf-rule:
	$(MAKE) -C $(bdftopcf) all

install-bdftopcf-rule: $(call installed,libXfont)
	$(MAKE) -C $(bdftopcf) install
