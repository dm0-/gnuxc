libwebp                 := libwebp-0.5.0
libwebp_sha1            := d3de815b272fcf88fc4f2dc1ab65d176bcb8df68
libwebp_url             := http://storage.googleapis.com/downloads.webmproject.org/releases/webp/$(libwebp).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-everything \
		--enable-experimental \
		--enable-{gif,jpeg,png,tiff} \
		--enable-libwebp{decoder,demux,extras,mux} \
		--enable-swap-16bit-csp \
		--enable-threading \
		\
		$(if $(DEBUG),--enable-asserts,--disable-asserts) \
		\
		--disable-wic \
		--disable-gl # This wants GLUT, not GL.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,giflib libpng tiff)
	$(MAKE) -C $(builddir) install
