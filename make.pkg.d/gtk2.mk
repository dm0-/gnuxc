gtk2                    := gtk+-2.24.31
gtk2_sha1               := c3d828135994a52cc9428a60175bd2b294656611
gtk2_url                := http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/$(gtk2).tar.xz

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
	$(INSTALL) -Dpm 644 $(call addon-file,gtkrc) $(DESTDIR)/etc/gtk-2.0/gtkrc

# Write inline files.
$(call addon-file,gtkrc): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,gtkrc)


# Provide a default configuration to use the correct key bindings, etc.
override define contents
gtk-button-images = 1
gtk-key-theme-name = "Emacs"
gtk-menu-images = 1
endef
$(call addon-file,gtkrc): private override contents := $(value contents)
