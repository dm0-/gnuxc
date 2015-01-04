gdk-pixbuf              := gdk-pixbuf-2.30.8
gdk-pixbuf_url          := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.30/$(gdk-pixbuf).tar.xz

prepare-gdk-pixbuf-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(gdk-pixbuf)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(gdk-pixbuf)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(gdk-pixbuf)/configure

configure-gdk-pixbuf-rule:
	cd $(gdk-pixbuf) && ./$(configure) \
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

build-gdk-pixbuf-rule:
	$(MAKE) -C $(gdk-pixbuf) all

install-gdk-pixbuf-rule: $(call installed,glib jasper libpng libX11 tiff)
	$(MAKE) -C $(gdk-pixbuf) install
