libjpeg-turbo           := libjpeg-turbo-1.4.2
libjpeg-turbo_url       := http://prdownloads.sourceforge.net/libjpeg-turbo/$(libjpeg-turbo).tar.gz

$(prepare-rule):
	$(RM) $(builddir)/configure

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
