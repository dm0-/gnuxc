isl                     := isl-0.12.1
isl_url                 := http://isl.gforge.inria.fr/$(isl).tar.lzma

configure-isl-rule:
	cd $(isl) && ./$(configure) \
		--disable-silent-rules \
		--enable-portable-binary \
		--with-gcc-arch=$(arch) \
		--with-gmp=system \
		--with-piplib=system

build-isl-rule:
	$(MAKE) -C $(isl) all

install-isl-rule: $(call installed,piplib)
	$(MAKE) -C $(isl) install
