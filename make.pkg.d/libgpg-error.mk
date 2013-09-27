libgpg-error            := libgpg-error-1.12
libgpg-error_url        := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$(libgpg-error).tar.bz2

configure-libgpg-error-rule:
	cd $(libgpg-error) && ./$(configure) \
		--disable-rpath \
		--enable-static

build-libgpg-error-rule:
	$(MAKE) -C $(libgpg-error) all

install-libgpg-error-rule: $(call installed,glibc)
	$(MAKE) -C $(libgpg-error) install
