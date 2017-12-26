gtk+                    := gtk+-3.22.26
gtk+_sha1               := aa6730ac00ea2352c522c3971f63b708b971bc5f
gtk+_url                := http://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/$(gtk+).tar.xz

$(prepare-rule):
	$(SED) -i.orig 's/ atk-bridge-2.0//' $(builddir)/configure.ac $(builddir)/configure
	for f in $(builddir)/configure{.ac,} ; do $(TOUCH) --reference=$$f.orig $$f ; done
	$(EDIT) '/atk[-_]bridge/d' $(builddir)/gtk/a11y/gtkaccessibility.c

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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
	$(INSTALL) -Dpm 0644 $(call addon-file,settings.ini) $(DESTDIR)/etc/gtk-3.0/settings.ini

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
