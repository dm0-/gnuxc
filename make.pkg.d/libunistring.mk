libunistring            := libunistring-0.9.6
libunistring_sha1       := d34dd5371c4b34863a880f2206e2d00532effdd6
libunistring_url        := http://ftpmirror.gnu.org/libunistring/$(libunistring).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-threads=posix \
		PACKAGE_TARNAME=libunistring \
		\
		--disable-relocatable # This results in undefined symbols when linking.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
