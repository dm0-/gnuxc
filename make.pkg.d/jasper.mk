jasper                  := jasper-1.900.31
jasper_branch           := $(jasper:jasper-%=jasper-version-%)
jasper_sha1             := a5cbbfa763f8b66a46f8f964afe4beb117a1d8a0
jasper_url              := http://github.com/mdadams/jasper/archive/$(jasper_branch:jasper-%=%).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-debug \
		--enable-libjpeg \
		--with-x \
		EXTRACFLAGS='$(CFLAGS)' \
		\
		--disable-opengl # This requires libGLUT.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libjpeg-turbo)
	$(MAKE) -C $(builddir) install
