wget                    := wget-1.17
wget_url                := http://ftpmirror.gnu.org/wget/$(wget).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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
		--with-libidn \
		--with-libuuid \
		--with-ssl=gnutls \
		--with-zlib \
		--without-included-regex \
		\
		--without-libpsl \
		--without-metalink

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,e2fsprogs gnutls pcre)
	$(MAKE) -C $(builddir) install
