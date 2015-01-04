libjpeg-turbo           := libjpeg-turbo-1.3.1
libjpeg-turbo_url       := http://prdownloads.sourceforge.net/libjpeg-turbo/$(libjpeg-turbo).tar.gz

prepare-libjpeg-turbo-rule:
	$(RM) $(libjpeg-turbo)/configure

configure-libjpeg-turbo-rule:
	cd $(libjpeg-turbo) && ./$(configure) \
		--disable-silent-rules \
		--with-arith-{enc,dec} \
		--with-simd \
		--with-turbojpeg \
		\
		--without-java

build-libjpeg-turbo-rule:
	$(MAKE) -C $(libjpeg-turbo) all

install-libjpeg-turbo-rule: $(call installed,glibc)
	$(MAKE) -C $(libjpeg-turbo) install \
		docdir=/usr/share/doc/libjpeg-turbo \
		exampledir=/usr/share/doc/libjpeg-turbo
