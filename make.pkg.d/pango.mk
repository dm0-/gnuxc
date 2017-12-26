pango                   := pango-1.40.14
pango_sha1              := 3a3073b79b07f92476276e2457842c92d8374064
pango_url               := http://ftp.gnome.org/pub/gnome/sources/pango/1.40/$(pango).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-debug \
		--enable-static \
		--with-cairo \
		--with-xft \
		\
		--disable-introspection

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,harfbuzz libXft)
	$(MAKE) -C $(builddir) install
