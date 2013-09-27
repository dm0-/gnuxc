libunistring            := libunistring-0.9.3
libunistring_url        := http://ftp.gnu.org/gnu/libunistring/$(libunistring).tar.gz

configure-libunistring-rule:
	cd $(libunistring) && ./$(configure) \
		--disable-rpath \
		--enable-relocatable \
		--enable-threads=posix

build-libunistring-rule:
	$(MAKE) -C $(libunistring) all

install-libunistring-rule: $(call installed,glibc)
	$(MAKE) -C $(libunistring) install
