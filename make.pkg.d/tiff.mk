tiff                    := tiff-4.0.3
tiff_url                := ftp://ftp.remotesensing.org/pub/libtiff/$(tiff).tar.gz

prepare-tiff-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(tiff)/config/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(tiff)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(tiff)/configure

configure-tiff-rule:
	cd $(tiff) && ./$(configure) \
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
		--with-x

build-tiff-rule:
	$(MAKE) -C $(tiff) all

install-tiff-rule: $(call installed,jbigkit libjpeg-turbo xz zlib)
	$(MAKE) -C $(tiff) install
