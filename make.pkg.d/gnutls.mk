gnutls                  := gnutls-3.6.1
gnutls_key              := 1F42418905D8206AA754CCDC29EE58B996865171
gnutls_url              := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.6/$(gnutls).tar.xz

$(prepare-rule):
# Cross-compiling wants to call libs.
	$(EDIT) 's/GUILD=.*/GUILD=/' $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-{sha1,ssl2,ssl3}-support \
		--enable-cxx \
		--enable-gcc-warnings \
		--enable-guile \
		--enable-openssl-compatibility \
		--enable-static \
		--with-default-trust-store-file=/etc/ssl/ca-bundle.pem \
		--with-idn \
		--with-p11-kit \
		--without-included-libtasn1 \
		--without-included-unistring \
		--without-nettle-mini \
		\
		--disable-guile \
		--disable-libdane \
		--without-tpm

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,guile libidn2 nettle p11-kit zlib)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -dm 0755 $(DESTDIR)/etc/ssl
