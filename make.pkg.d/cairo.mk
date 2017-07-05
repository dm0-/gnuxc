cairo                   := cairo-1.14.10
cairo_sha1              := 28c59d85d6b790c21b8b59ece73a6a1dda28d69a
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
