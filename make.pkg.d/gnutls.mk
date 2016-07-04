gnutls                  := gnutls-3.5.1
gnutls_sha1             := 027df6cd692dfd5310441ef2c843def217986ece
gnutls_url              := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$(gnutls).tar.xz

$(prepare-rule):
# Cross-compiling wants to call libs.
	$(EDIT) 's/GUILD=.*/GUILD=/' $(builddir)/configure
# Fix the new header names.
	$(EDIT) 's/gnutls_\(global\|errors\)/\1/' $(builddir)/extra/openssl_compat.c

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-cxx \
		--enable-gcc-warnings \
		--enable-guile \
		--enable-openssl-compatibility \
		--enable-static \
		--with-default-trust-store-file=/etc/ssl/ca-bundle.pem \
		--with-idn \
		--with-p11-kit \
		--with-zlib \
		--without-included-libtasn1 \
		--without-nettle-mini \
		\
		--disable-libdane \
		--without-tpm

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile libidn nettle p11-kit zlib)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -dm 755 $(DESTDIR)/etc/ssl
