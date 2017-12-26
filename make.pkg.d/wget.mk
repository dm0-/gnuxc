wget                    := wget-1.19.2
wget_key                := 1CB27DBC98614B2D5841646D08302DB6A2670428
wget_url                := http://ftpmirror.gnu.org/wget/$(wget).tar.lz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--enable-assert \
		--enable-debug \
		--enable-digest \
		--enable-ipv6 \
		--enable-iri \
		--enable-ntlm \
		--enable-opie \
		--enable-pcre \
		--enable-threads=posix \
		--enable-xattr \
		--with-libidn \
		--with-libuuid \
		--with-ssl=gnutls \
		--with-zlib \
		--without-included-libunistring \
		--without-included-regex \
		\
		--without-cares \
		--without-libpsl \
		--without-metalink

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,e2fsprogs gnutls pcre)
	$(MAKE) -C $(builddir) install
