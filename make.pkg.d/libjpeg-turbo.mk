libjpeg-turbo           := libjpeg-turbo-1.5.1
libjpeg-turbo_sha1      := ebb3f9e94044c77831a3e8c809c7ea7506944622
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
