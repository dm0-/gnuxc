librsvg                 := librsvg-2.40.17
librsvg_sha1            := dc70382cb8636a6cc28d2b61677e0bb59dda2dcd
librsvg_url             := http://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/$(librsvg).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-pixbuf-loader \
		--enable-tools \
		\
		--disable-vala --disable-introspection

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gdk-pixbuf libcroco pango)
	$(MAKE) -C $(builddir) install
