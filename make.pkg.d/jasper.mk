jasper                  := jasper-1.900.1
jasper_sha1             := 9c5735f773922e580bf98c7c7dfda9bbed4c5191
jasper_url              := http://www.ece.uvic.ca/~frodo/jasper/software/$(jasper).zip

$(prepare-rule):
	$(RM) $(builddir)/configure
	chmod -R go-w $(builddir)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-debug \
		--enable-libjpeg \
		--enable-shared \
		--with-x \
		EXTRACFLAGS='$(CFLAGS)' \
		\
		--disable-opengl # This requires libGLUT.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libjpeg-turbo)
	$(MAKE) -C $(builddir) install
