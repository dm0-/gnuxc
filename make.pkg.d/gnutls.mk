gnutls                  := gnutls-3.5.14
gnutls_sha1             := cfb537e6c1da4c3676b273da2427bb5132f6b5fc
gnutls_url              := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$(gnutls).tar.xz

$(prepare-rule):
# Cross-compiling wants to call libs.
	$(EDIT) 's/GUILD=.*/GUILD=/' $(builddir)/configure

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
		--with-libidn2 \
		--with-p11-kit \
		--with-zlib \
		--without-included-libtasn1 \
		--without-included-unistring \
		--without-nettle-mini \
		\
		--disable-libdane \
		--without-tpm

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile libidn2 nettle p11-kit zlib)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -dm 755 $(DESTDIR)/etc/ssl
