libgcrypt               := libgcrypt-1.8.2
libgcrypt_key           := D8692123C4065DEA5E0F3AB5249B39D24F25E3B6 031EC2536E580D8EA286A9F22071B08A33BD3F06
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
		--enable-dev-random \
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
