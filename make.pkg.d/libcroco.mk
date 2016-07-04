libcroco                := libcroco-0.6.11
libcroco_sha1           := 35203ccb3c30ae1d0956a362c6aabe6109e582f3
libcroco_url            := http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/$(libcroco).tar.xz

$(configure-rule):
# Help the configure script correctly edit the build options.
	$(EDIT) $(builddir)/croco-config.in \
		-e "s,@\(GLIB2_CFLAGS\)@,-I`$(PKG_CONFIG) glib-2.0 --variable=includedir`/glib-2.0 -I`$(PKG_CONFIG) glib-2.0 --variable=libdir`/glib-2.0/include,g" \
		-e "s,@\(LIBXML2_CFLAGS\)@,-I`$(PKG_CONFIG) libxml-2.0 --variable=includedir`/libxml2,g" \
		-e 's/@\(CROCO_CFLAGS\|\(GLIB\|LIBXML\)2_LIBS\)@//g'
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-checks

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glib libxml2)
	$(MAKE) -C $(builddir) install
