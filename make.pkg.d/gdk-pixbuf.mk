gdk-pixbuf              := gdk-pixbuf-2.32.2
gdk-pixbuf_url          := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.32/$(gdk-pixbuf).tar.xz

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-debug \
		--enable-explicit-deps \
		--enable-gio-sniffing \
		--enable-modules \
		--enable-static \
		--with-libjasper \
		--with-libjpeg \
		--with-libpng \
		--with-libtiff \
		--with-x11 \
		\
		--disable-glibtest \
		--disable-introspection

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib jasper libpng libX11 tiff)
	$(MAKE) -C $(builddir) install
