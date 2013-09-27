libxml2                 := libxml2-2.9.1
libxml2_url             := ftp://xmlsoft.org/libxml2/$(libxml2).tar.gz

configure-libxml2-rule:
	cd $(libxml2) && ./$(configure) \
		--disable-silent-rules \
		--with-fexceptions \
		--with-history \
		--with-mem-debug \
		--with-run-debug \
		--with-thread-alloc \
		\
		--without-icu \
		--without-python

build-libxml2-rule:
	$(MAKE) -C $(libxml2) all

install-libxml2-rule: $(call installed,readline xz zlib)
	$(MAKE) -C $(libxml2) install
