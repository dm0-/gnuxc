libunistring            := libunistring-0.9.4
libunistring_url        := http://ftpmirror.gnu.org/libunistring/$(libunistring).tar.xz

configure-libunistring-rule:
	cd $(libunistring) && ./$(configure) \
		--disable-rpath \
		--enable-threads=posix \
		PACKAGE_TARNAME=libunistring \
		\
		--disable-relocatable # This results in undefined symbols when linking.

build-libunistring-rule:
	$(MAKE) -C $(libunistring) all

install-libunistring-rule: $(call installed,glibc)
	$(MAKE) -C $(libunistring) install
