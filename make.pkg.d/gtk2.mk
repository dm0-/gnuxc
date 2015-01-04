gtk2                    := gtk2-2.24.25
gtk2_branch             := $(gtk2:gtk2-%=gtk+-%)
gtk2_url                := http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/$(gtk2_branch).tar.xz

prepare-gtk2-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(gtk2)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(gtk2)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(gtk2)/configure

configure-gtk2-rule:
	cd $(gtk2) && ./$(configure) \
		--enable-debug \
		--enable-modules \
		--enable-shm \
		--enable-static \
		--enable-visibility \
		--enable-xinerama \
		--enable-xkb \
		--with-gdktarget=x11 \
		--with-x \
		--with-xinput \
		\
		--disable-cups

build-gtk2-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(gtk2)/gtk gtk-update-icon-cache.build CC=gcc EXEEXT=.build GMODULE_CFLAGS= \
		GTK_DEP_CFLAGS="`pkg-config --cflags gdk-pixbuf-2.0`" \
		GDK_PIXBUF_LIBS="`pkg-config --libs gdk-pixbuf-2.0`"
	$(RM) $(gtk2)/gtk/updateiconcache.o
	$(MAKE) -C $(gtk2) all GTK_UPDATE_ICON_CACHE=$(CURDIR)/$(gtk2)/gtk/gtk-update-icon-cache.build
else
	$(MAKE) -C $(gtk2) all
endif

install-gtk2-rule: $(call installed,atk gdk-pixbuf libXi libXinerama libXrandr pango)
	$(MAKE) -C $(gtk2) install
