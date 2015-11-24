librsvg                 := librsvg-2.40.11
librsvg_url             := http://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/$(librsvg).tar.xz

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh)

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
