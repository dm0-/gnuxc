libjpeg-turbo           := libjpeg-turbo-1.5.0
libjpeg-turbo_sha1      := 9adc21b927e48e4c6889e77079f6c1f3eecf98ab
libjpeg-turbo_url       := http://prdownloads.sourceforge.net/libjpeg-turbo/$(libjpeg-turbo).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--with-arith-{enc,dec} \
		--with-simd \
		--with-turbojpeg \
		\
		--without-java

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		docdir=/usr/share/doc/libjpeg-turbo \
		exampledir=/usr/share/doc/libjpeg-turbo
