gtk2                    := gtk2-2.24.28
gtk2_branch             := $(gtk2:gtk2-%=gtk+-%)
gtk2_url                := http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/$(gtk2_branch).tar.xz

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

ifneq ($(host),$(build))
$(builddir)/gtk/gtk-update-icon-cache.build: $(configured)
	$(RM) $(builddir)/gtk/updateiconcache.o
	$(MAKE) -C $(builddir)/gtk gtk-update-icon-cache.build CC=gcc EXEEXT=.build GMODULE_CFLAGS= \
		GTK_DEP_CFLAGS="`pkg-config --cflags gdk-pixbuf-2.0`" \
		GDK_PIXBUF_LIBS="`pkg-config --libs gdk-pixbuf-2.0`"
	$(RM) $(builddir)/gtk/updateiconcache.o
$(build-rule): $(builddir)/gtk/gtk-update-icon-cache.build
$(build-rule): private override configuration := GTK_UPDATE_ICON_CACHE=$(CURDIR)/$(builddir)/gtk/gtk-update-icon-cache.build
endif

$(build-rule):
	$(MAKE) -C $(builddir) all $(configuration)

$(install-rule): $$(call installed,atk gdk-pixbuf libXdamage libXi libXinerama libXrandr pango)
	$(MAKE) -C $(builddir) install
