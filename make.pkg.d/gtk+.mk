gtk+                    := gtk+-3.18.5
gtk+_url                := http://ftp.gnome.org/pub/gnome/sources/gtk+/3.18/$(gtk+).tar.xz

$(prepare-rule):
	$(EDIT) 's/ atk-bridge-2.0//' $(builddir)/configure.ac
	$(EDIT) '/atk[-_]bridge/d' $(builddir)/gtk/a11y/gtkaccessibility.c
	$(AUTOGEN) $(builddir)
	$(call drop-rpath,configure,build-aux/ltmain.sh)

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
