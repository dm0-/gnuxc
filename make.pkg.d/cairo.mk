cairo                   := cairo-1.14.6
cairo_sha1              := 0a59324e6cbe031b5b898ff8b9e2ffceb9d114f5
cairo_url               := http://cairographics.org/releases/$(cairo).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-fc \
		--enable-ft \
		--enable-gobject \
		--enable-interpreter \
		--enable-pdf \
		--enable-png \
		--enable-ps \
		--enable-pthread \
		--enable-script \
		--enable-svg \
		--enable-symbol-lookup \
		--enable-tee \
		--enable-test-surfaces \
		--enable-trace \
		--enable-xcb \
		--enable-xcb-shm \
		--enable-xlib \
		--enable-xlib-xcb \
		--enable-xlib-xrender \
		--enable-xml \
		--with-x \
		CPPFLAGS='-DMAP_NORESERVE=0' \
		\
		--disable-drm \
		--disable-gallium \
		--disable-qt \
		--disable-vg

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,binutils libXmu libXpm)
	$(MAKE) -C $(builddir) install
