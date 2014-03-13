wget                    := wget-1.15
wget_url                := http://ftp.gnu.org/gnu/wget/$(wget).tar.xz

configure-wget-rule:
	cd $(wget) && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-digest \
		--enable-ipv6 \
		--enable-iri \
		--enable-ntlm \
		--enable-opie \
		--enable-threads=posix \
		--with-libidn \
		--with-ssl=gnutls \
		--with-zlib \
		--without-included-regex

build-wget-rule:
	$(MAKE) -C $(wget) all

install-wget-rule: $(call installed,e2fsprogs gnutls pcre)
	$(MAKE) -C $(wget) install
