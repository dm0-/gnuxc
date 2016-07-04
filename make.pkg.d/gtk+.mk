gtk+                    := gtk+-3.20.6
gtk+_sha1               := 36ddab46242eb2da5d716771fd6132582e5828cc
gtk+_url                := http://ftp.gnome.org/pub/gnome/sources/gtk+/3.20/$(gtk+).tar.xz

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
