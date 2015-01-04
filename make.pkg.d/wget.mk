wget                    := wget-1.16.1
wget_url                := http://ftpmirror.gnu.org/wget/$(wget).tar.xz

configure-wget-rule:
	cd $(wget) && ./$(configure) \
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
		--without-libpsl

build-wget-rule:
	$(MAKE) -C $(wget) all

install-wget-rule: $(call installed,e2fsprogs gnutls pcre)
	$(MAKE) -C $(wget) install
