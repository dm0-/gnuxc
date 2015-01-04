libffi                  := libffi-3.2.1
libffi_url              := ftp://sourceware.org/pub/libffi/$(libffi).tar.gz

configure-libffi-rule:
	cd $(libffi) && ./$(configure) \
		--enable-debug

build-libffi-rule:
	$(MAKE) -C $(libffi) all

install-libffi-rule: $(call installed,glibc)
	$(MAKE) -C $(libffi) install
