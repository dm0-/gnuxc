libunistring            := libunistring-0.9.7
libunistring_sha1       := 7d92687a50fea7702e8052486dfa25ffc361c9f3
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
