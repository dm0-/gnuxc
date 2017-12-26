gnupg                   := gnupg-2.2.4
gnupg_key               := D8692123C4065DEA5E0F3AB5249B39D24F25E3B6 031EC2536E580D8EA286A9F22071B08A33BD3F06
gnupg_url               := ftp://ftp.gnupg.org/gcrypt/gnupg/$(gnupg).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-gpg-is-gpg2 \
		--disable-rpath \
		--enable-{dirmngr,doc,g13,gpg,gpgsm,gpgtar,scdaemon,symcryptrun,wks-tools} \
		--enable-bzip2 \
		--enable-gnutls \
		--enable-large-secmem \
		--enable-photo-viewers \
		--enable-regex \
		--enable-sqlite \
		--enable-zip \
		\
		--disable-ldap \
		--disable-libdns \
		--disable-ntbtls \
		--disable-selinux-support \
		--without-capabilities

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bzip2 gnutls libassuan libgcrypt libksba npth sqlite)
	$(MAKE) -C $(builddir) install
