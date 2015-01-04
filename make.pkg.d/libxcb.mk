libxcb                  := libxcb-1.11
libxcb_url              := http://xcb.freedesktop.org/dist/$(libxcb).tar.bz2

prepare-libxcb-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(libxcb){,/build-aux}/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(libxcb)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(libxcb)/configure

configure-libxcb-rule:
	cd $(libxcb) && ./$(configure) \
		--disable-silent-rules \
		--enable-composite \
		--enable-damage \
		--enable-dpms \
		--enable-dri2 \
		--enable-dri3 \
		--enable-glx \
		--enable-present \
		--enable-randr \
		--enable-record \
		--enable-render \
		--enable-resource \
		--enable-screensaver \
		--enable-selinux \
		--enable-shape \
		--enable-shm \
		--enable-sync \
		--enable-xevie \
		--enable-xfixes \
		--enable-xfree86-dri \
		--enable-xinerama \
		--enable-xinput \
		--enable-xkb \
		--enable-xprint \
		--enable-xtest \
		--enable-xv \
		--enable-xvmc

build-libxcb-rule:
	$(MAKE) -C $(libxcb) all

install-libxcb-rule: $(call installed,libpthread-stubs libXau xcb-proto)
	$(MAKE) -C $(libxcb) install
