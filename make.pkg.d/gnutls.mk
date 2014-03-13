gnutls                  := gnutls-3.2.12.1
gnutls_branch           := gnutls-3.2.12
gnutls_url              := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/$(gnutls).tar.lz

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
		--enable-threads=posix \
		--with-default-trust-store-file=/etc/ssl/ca-bundle.pem \
		--with-zlib \
		--without-included-libtasn1 \
		\
		--disable-libdane \
		--without-p11-kit \
		--without-tpm

build-gnutls-rule:
	$(MAKE) -C $(gnutls) all

install-gnutls-rule: $(call installed,guile libidn libtasn1 nettle zlib)
	$(MAKE) -C $(gnutls) install
	$(INSTALL) -dm 755 $(DESTDIR)/etc/ssl
