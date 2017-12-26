tiff                    := tiff-4.0.9
tiff_sha1               := 87d4543579176cc568668617c22baceccd568296
tiff_url                := http://download.osgeo.org/libtiff/$(tiff).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-ccitt \
		--enable-check-ycbcr-subsampling \
		--enable-chunky-strip-read \
		--enable-cxx \
		--enable-defer-strile-load \
		--enable-extrasample-as-alpha \
		--enable-jbig \
		--enable-jpeg \
		--enable-jpeg12 --with-jpeg12-include-dir='$(sysroot)/usr/include' \
		--enable-logluv \
		--enable-lzma \
		--enable-lzw \
		--enable-mdi \
		--enable-next \
		--enable-old-jpeg \
		--enable-packbits \
		--enable-pixarlog \
		--enable-strip-chopping \
		--enable-thunder \
		--enable-zlib \
		--with-docdir='$${datarootdir}/doc/tiff' \
		--with-x

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,jbigkit libjpeg-turbo xz zlib)
	$(MAKE) -C $(builddir) install
