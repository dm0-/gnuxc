libcroco                := libcroco-0.6.8
libcroco_url            := http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/$(libcroco).tar.xz

prepare-libcroco-rule:
	$(EDIT) $(libcroco)/croco-config.in \
		-e "s,@\(GLIB2_CFLAGS\)@,-I`$(PKG_CONFIG) glib-2.0 --variable=includedir`/glib-2.0 -I`$(PKG_CONFIG) glib-2.0 --variable=libdir`/glib-2.0/include,g" \
		-e "s,@\(LIBXML2_CFLAGS\)@,-I`$(PKG_CONFIG) libxml-2.0 --variable=includedir`/libxml2,g" \
		-e 's/@\(CROCO_CFLAGS\|\(GLIB\|LIBXML\)2_LIBS\)@//g'

configure-libcroco-rule:
	cd $(libcroco) && ./$(configure) \
		--disable-silent-rules \
		--enable-checks

build-libcroco-rule:
	$(MAKE) -C $(libcroco) all

install-libcroco-rule: $(call installed,glib libxml2)
	$(MAKE) -C $(libcroco) install
