libwebp                 := libwebp-0.6.0
libwebp_sha1            := 156d24fff454bfccd1f44434e226a10d9eb38186
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
