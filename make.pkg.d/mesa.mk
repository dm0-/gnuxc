mesa                    := mesa-11.2.2
mesa_sha1               := c3805020be6fef77d3b96a5ddf4ddc256dee16ff
mesa_url                := ftp://ftp.freedesktop.org/pub/$(subst -,/,$(mesa))/$(mesa).tar.xz

$(prepare-rule):
	$(call apply,hurd-port)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--disable-texture-float \
		--disable-xlib-glx \
		--enable-asm \
		--enable-dri --enable-dri3 \
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
		--with-sha1=libnettle \
		\
		$(if $(DEBUG),--enable-debug,--disable-debug) \
		\
		--disable-gbm \
		--disable-nine \
		--disable-selinux \
		--disable-static \
		--disable-sysfs \
		--disable-xa \
		CPPFLAGS=-DPATH_MAX=4096

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,expat glproto libXdamage libXext nettle)
	$(MAKE) -C $(builddir) install
