ImageMagick             := ImageMagick-7.0.7-15
ImageMagick_key         := D8272EF51DA223E4D05B466989AB63D48277377A
ImageMagick_url         := http://www.imagemagick.org/download/releases/$(ImageMagick).tar.xz
ImageMagick_sig         := $(ImageMagick_url).asc

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-bounds-checking \
		--enable-hdri \
		--enable-hugepages \
		--enable-openmp \
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
