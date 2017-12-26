libjpeg-turbo           := libjpeg-turbo-1.5.3
libjpeg-turbo_key       := 7D6293CC6378786E1B5C496885C7044E033FDE16
libjpeg-turbo_url       := http://prdownloads.sourceforge.net/libjpeg-turbo/$(libjpeg-turbo).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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
