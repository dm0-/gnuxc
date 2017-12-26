mesa                    := mesa-17.3.1
mesa_key                := 8703B6700E7EE06D7A39B8D6EDAE37B02CEB490D
mesa_url                := ftp://ftp.freedesktop.org/pub/mesa/$(mesa).tar.xz

$(prepare-rule):
	$(call apply,hurd-port)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-texture-float \
		--enable-asm \
		--enable-dri \
		--enable-egl \
		--enable-gallium-osmesa \
		--enable-gles1 \
		--enable-gles2 \
		--enable-glx \
		--enable-glx-tls \
		--enable-opengl \
		--enable-shared-glapi \
		--with-dri-drivers=swrast \
		--with-gallium-drivers=swrast \
		--with-platforms=x11 \
		\
		$(if $(DEBUG),--enable-debug,--disable-debug) \
		\
		--disable-dri3 \
		--disable-gbm \
		--disable-nine \
		--disable-selinux \
		--disable-static \
		--disable-xa \
		CPPFLAGS=-DPATH_MAX=4096 \
		PYTHON2=$(PYTHON)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,expat glproto libXdamage libXext zlib)
	$(MAKE) -C $(builddir) install
