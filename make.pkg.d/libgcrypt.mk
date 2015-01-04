libgcrypt               := libgcrypt-1.6.2
libgcrypt_url           := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$(libgcrypt).tar.bz2

ifeq ($(host),$(build))
export LIBGCRYPT_CONFIG = libgcrypt-config
else
export LIBGCRYPT_CONFIG = $(host)-libgcrypt-config
endif

prepare-libgcrypt-rule:
	$(PATCH) -d $(libgcrypt) < $(patchdir)/$(libgcrypt)-build-fixes.patch
ifneq ($(host),$(build))
	$(EDIT) 's/@GPG_ERROR_CFLAGS@//;s/@GPG_ERROR_LIBS@/-lgpg-error/' $(libgcrypt)/src/libgcrypt-config.in
endif

configure-libgcrypt-rule:
	cd $(libgcrypt) && ./$(configure) \
		--enable-hmac-binary-check \
		--enable-m-guard \
		--enable-static \
		--enable-threads=posix \
		\
		--disable-asm

build-libgcrypt-rule:
	$(MAKE) -C $(libgcrypt) all

install-libgcrypt-rule: $(call installed,libgpg-error)
	$(MAKE) -C $(libgcrypt) install
