gdk-pixbuf              := gdk-pixbuf-2.36.11
gdk-pixbuf_sha1         := 445bb95b234c3b3cea273353b7464f3b796dbd0e
gdk-pixbuf_url          := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/$(gdk-pixbuf).tar.xz

$(prepare-rule):
# Drop a bad prerequisite.
	$(EDIT) 's, [^ ]*/loaders.cache$$,,' $(builddir)/thumbnailer/Makefile.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-explicit-deps \
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

$(install-rule): $$(call installed,jasper libpng libX11 shared-mime-info tiff)
	$(MAKE) -C $(builddir) install
