gnutls                  := gnutls-3.4.7
gnutls_url              := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/$(gnutls).tar.xz

$(prepare-rule):
	$(call drop-rpath,configure,build-aux/ltmain.sh)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-openssl-compatibility \
		--disable-rpath \
		--disable-silent-rules \
		--enable-cxx \
		--enable-gcc-warnings \
		--enable-guile \
		--enable-static \
		--with-default-trust-store-file=/etc/ssl/ca-bundle.pem \
		--with-idn \
		--with-p11-kit \
		--with-zlib \
		--without-included-libtasn1 \
		--without-nettle-mini \
		GUILE_CONFIG='/usr/bin/$(GUILE_CONFIG)' \
		\
		--disable-libdane \
		--without-tpm

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile libidn nettle p11-kit zlib)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -dm 755 $(DESTDIR)/etc/ssl
