libwebp                 := libwebp-0.6.1
libwebp_sha1            := 643aea0e04fd66b9251c89217c4e5133ae5dd980
libwebp_url             := http://storage.googleapis.com/downloads.webmproject.org/releases/webp/$(libwebp).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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
