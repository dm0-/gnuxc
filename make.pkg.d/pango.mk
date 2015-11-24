pango                   := pango-1.38.1
pango_url               := http://ftp.gnome.org/pub/gnome/sources/pango/1.38/$(pango).tar.xz

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
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
