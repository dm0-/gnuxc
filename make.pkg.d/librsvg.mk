librsvg                 := librsvg-2.37.0
librsvg_url             := http://ftp.gnome.org/pub/gnome/sources/librsvg/2.37/$(librsvg).tar.xz

prepare-librsvg-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(librsvg)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(librsvg)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(librsvg)/configure

configure-librsvg-rule:
	cd $(librsvg) && ./$(configure) \
		--disable-silent-rules \
		--enable-pixbuf-loader \
		\
		--disable-gtk-theme \
		--disable-vala --disable-introspection

build-librsvg-rule:
	$(MAKE) -C $(librsvg) all

install-librsvg-rule: $(call installed,gdk-pixbuf libcroco pango)
	$(MAKE) -C $(librsvg) install
