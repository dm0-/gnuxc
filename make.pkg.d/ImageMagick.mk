ImageMagick             := ImageMagick-7.0.2-2
ImageMagick_sha1        := b407a9033dd2a017a421d90bef1cbb2a1e96621e
ImageMagick_url         := http://www.imagemagick.org/download/releases/$(ImageMagick).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-bounds-checking \
		--enable-hdri \
		--enable-hugepages \
		--enable-openmp \
		--disable-silent-rules \
		--with-bzlib \
		--with-fontconfig \
		--with-freetype \
		--with-jbig \
		--with-jpeg \
		--with-lzma \
		--with-magick-plus-plus \
		--with-modules \
		--with-pango \
		--with-png \
		--with-rsvg \
		--with-tiff \
		--with-webp \
		--with-x \
		--with-xml \
		--with-zlib \
		\
		$(if $(DEBUG),--enable-assert,--disable-assert) \
		$(if $(filter $(host),$(build)),--with-perl,--without-perl) \
		\
		--disable-opencl \
		--without-autotrace \
		--without-djvu \
		--without-dps \
		--without-fftw \
		--without-fpx \
		--without-gslib \
		--without-gvc \
		--without-lcms \
		--without-lqr \
		--without-openexr \
		--without-openjp2 \
		--without-wmf

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bzip2 librsvg libtool libwebp)
	$(MAKE) -C $(builddir) install
