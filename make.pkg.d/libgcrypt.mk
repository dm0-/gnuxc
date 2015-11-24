libgcrypt               := libgcrypt-1.6.4
libgcrypt_url           := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$(libgcrypt).tar.bz2

ifeq ($(host),$(build))
export LIBGCRYPT_CONFIG = libgcrypt-config
else
export LIBGCRYPT_CONFIG = $(host)-libgcrypt-config
endif

$(prepare-rule):
	$(call apply,build-fixes)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-hmac-binary-check \
		--enable-m-guard \
		--enable-static \
		--enable-threads=posix \
		\
		--disable-asm

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libgpg-error)
	$(MAKE) -C $(builddir) install
