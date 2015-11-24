mesa                    := mesa-11.0.6
mesa_url                := ftp://ftp.freedesktop.org/pub/$(subst -,/,$(mesa))/$(mesa).tar.xz

$(prepare-rule):
	$(call apply,hurd-port)
	$(call drop-rpath,configure,bin/ltmain.sh)

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
		\
		$(if $(DEBUG),--enable-debug,--disable-debug) \
		\
		--disable-gbm \
		--disable-nine \
		--disable-selinux \
		--disable-static \
		--disable-sysfs \
		--disable-xa

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,expat glproto libXdamage libXext)
	$(MAKE) -C $(builddir) install
