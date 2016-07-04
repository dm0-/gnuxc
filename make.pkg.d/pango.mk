pango                   := pango-1.40.1
pango_sha1              := 4021b704c2da2ca5ebfc51c714053b7e1907282c
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
