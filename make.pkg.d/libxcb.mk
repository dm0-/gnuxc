libxcb                  := libxcb-1.11.1
libxcb_url              := http://xcb.freedesktop.org/dist/$(libxcb).tar.bz2

$(prepare-rule):
	$(call drop-rpath,configure,ltmain.sh build-aux/ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libpthread-stubs libXau xcb-proto)
	$(MAKE) -C $(builddir) install
