pango                   := pango-1.36.8
pango_url               := http://ftp.gnome.org/pub/gnome/sources/pango/1.36/$(pango).tar.xz

prepare-pango-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(pango)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(pango)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(pango)/configure

configure-pango-rule:
	cd $(pango) && ./$(configure) \
		--disable-silent-rules \
		--enable-debug \
		--enable-explicit-deps \
		--enable-static \
		--with-cairo \
		--with-xft \
		\
		--disable-introspection

build-pango-rule:
	$(MAKE) -C $(pango) all

install-pango-rule: $(call installed,harfbuzz libXft)
	$(MAKE) -C $(pango) install
	$(INSTALL) -dm 755 $(DESTDIR)/etc/pango
