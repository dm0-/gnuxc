mesa                    := mesa-17.1.4
mesa_sha1               := 70a6c971125f754b78e502ade668bd02e46074d6
mesa_url                := ftp://ftp.freedesktop.org/pub/mesa/$(mesa).tar.xz

$(prepare-rule):
	$(call apply,hurd-port)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
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
		CPPFLAGS=-DPATH_MAX=4096

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,expat glproto libXdamage libXext zlib)
	$(MAKE) -C $(builddir) install
