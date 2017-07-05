gtk+                    := gtk+-3.22.16
gtk+_sha1               := 7cfc2e024d1a09f5d2a2518335b62884570d429b
gtk+_url                := http://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/$(gtk+).tar.xz

$(prepare-rule):
	$(EDIT) 's/ atk-bridge-2.0//' $(builddir)/configure.ac
	$(EDIT) '/atk[-_]bridge/d' $(builddir)/gtk/a11y/gtkaccessibility.c
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-debug \
		--enable-modules \
		--enable-static \
		--enable-x11-backend \
		--enable-xdamage \
		--enable-xfixes \
		--enable-xinerama \
		--enable-xkb \
		--enable-xrandr \
		--with-x \
		\
		--disable-colord \
		--disable-glibtest \
		--disable-schemas-compile \
		--disable-xcomposite

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,adwaita-icon-theme atk gdk-pixbuf libXi libXinerama libXrandr mesa pango)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,settings.ini) $(DESTDIR)/etc/gtk-3.0/settings.ini

# Write inline files.
$(call addon-file,settings.ini): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,settings.ini)


# Provide a default configuration to use the correct key bindings, etc.
override define contents
[Settings]
gtk-button-images = true
gtk-key-theme-name = Emacs
gtk-menu-images = true
endef
$(call addon-file,settings.ini): private override contents := $(value contents)
