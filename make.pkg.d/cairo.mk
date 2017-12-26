cairo                   := cairo-1.15.10
cairo_sha1              := de180498ac563249b93ee5e17ba9aa26f90644b3
cairo_url               := http://cairographics.org/snapshots/$(cairo).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-atomic \
		--enable-egl \
		--enable-fc \
		--enable-ft \
		--enable-gl --disable-glesv2 \
		--enable-glx \
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
		\
		--disable-cogl \
		--disable-directfb \
		--disable-drm \
		--disable-gallium \
		--disable-qt \
		--disable-vg \
		--disable-wgl

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,binutils libXmu libXpm mesa)
	$(MAKE) -C $(builddir) install
