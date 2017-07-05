pango                   := pango-1.40.6
pango_sha1              := 83125850255f78f2130aa373d3fe46f61d064dab
pango_url               := http://ftp.gnome.org/pub/gnome/sources/pango/1.40/$(pango).tar.xz

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
