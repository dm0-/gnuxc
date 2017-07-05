wget                    := wget-1.19.1
wget_sha1               := cde25e99c144191644406793cbd1c69c102c6970
wget_url                := http://ftpmirror.gnu.org/wget/$(wget).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--disable-silent-rules \
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
