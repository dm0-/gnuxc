wget                    := wget-1.18
wget_sha1               := 02d451e658f600ee519c42cbf4d3bfe4e49b6c4f
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
