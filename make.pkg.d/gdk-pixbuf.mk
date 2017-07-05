gdk-pixbuf              := gdk-pixbuf-2.36.6
gdk-pixbuf_sha1         := 8caa99dbbb143cddbb896bf35e01da717bb1479f
gdk-pixbuf_url          := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/$(gdk-pixbuf).tar.xz

$(prepare-rule):
# Drop a bad prerequisite.
	$(EDIT) 's, [^ ]*/loaders.cache$$,,' $(builddir)/thumbnailer/Makefile.in

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
