jasper                  := jasper-1.900.1
jasper_url              := http://www.ece.uvic.ca/~frodo/jasper/software/$(jasper).zip

prepare-jasper-rule:
	$(DOWNLOAD) '$(jasper_url)' > $(jasper)/$(jasper).zip && unzip -q $(jasper)/$(jasper).zip
	$(RM) $(jasper)/configure
	chmod -R go-w $(jasper)

configure-jasper-rule:
	cd $(jasper) && ./$(configure) \
		--enable-debug \
		--enable-libjpeg \
		--enable-shared \
		--with-x \
		EXTRACFLAGS='$(CFLAGS)' \
		\
		--disable-opengl

build-jasper-rule:
	$(MAKE) -C $(jasper) all

install-jasper-rule: $(call installed,libjpeg-turbo)
	$(MAKE) -C $(jasper) install
