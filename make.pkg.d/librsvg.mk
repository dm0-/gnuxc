librsvg                 := librsvg-2.40.16
librsvg_sha1            := 6d800afa8d886eba9c3039875d4fc89a8004932f
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
