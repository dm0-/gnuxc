cairo                   := cairo-1.12.16
cairo_url               := http://cairographics.org/releases/$(cairo).tar.xz

prepare-cairo-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(cairo)/build/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(cairo)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(cairo)/configure

configure-cairo-rule:
	cd $(cairo) && ./$(configure) \
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

build-cairo-rule:
	$(MAKE) -C $(cairo) all

install-cairo-rule: $(call installed,binutils libXmu libXpm)
	$(MAKE) -C $(cairo) install
