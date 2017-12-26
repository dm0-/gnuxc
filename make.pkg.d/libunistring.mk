libunistring            := libunistring-0.9.8
libunistring_key        := 462225C3B46F34879FC8496CD605848ED7E69871
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
