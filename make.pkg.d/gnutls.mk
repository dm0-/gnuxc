gnutls                  := gnutls-3.3.11
gnutls_url              := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/$(gnutls).tar.lz

prepare-gnutls-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(gnutls)/{,build-aux/}ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(gnutls)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(gnutls)/configure

configure-gnutls-rule:
	cd $(gnutls) && ./$(configure) \
		--disable-openssl-compatibility \
		--disable-rpath \
		--disable-silent-rules \
		--enable-gcc-warnings \
		--enable-guile \
		--enable-static \
		--with-default-trust-store-file=/etc/ssl/ca-bundle.pem \
		--with-p11-kit \
		--with-zlib \
		--without-included-libtasn1 \
		GUILE_CONFIG='/usr/bin/$(GUILE_CONFIG)' \
		\
		--disable-libdane \
		--without-tpm

build-gnutls-rule:
	$(MAKE) -C $(gnutls) all

install-gnutls-rule: $(call installed,guile libidn nettle p11-kit zlib)
	$(MAKE) -C $(gnutls) install
	$(INSTALL) -dm 755 $(DESTDIR)/etc/ssl
