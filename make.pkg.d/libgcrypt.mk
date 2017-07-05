libgcrypt               := libgcrypt-1.7.8
libgcrypt_sha1          := 65a4a495aa858483e66868199eaa8238572ca6cd
libgcrypt_url           := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$(libgcrypt).tar.bz2

ifeq ($(host),$(build))
export LIBGCRYPT_CONFIG = /usr/bin/libgcrypt-config
else
export LIBGCRYPT_CONFIG = /usr/bin/$(host)-libgcrypt-config
endif

$(prepare-rule):
	$(call apply,build-fixes)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-hmac-binary-check \
		--enable-m-guard \
		--enable-static \
		\
		--disable-asm \
		--disable-random-daemon \
		--without-capabilities

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libgpg-error)
	$(MAKE) -C $(builddir) install
