libffi                  := libffi-3.2.1
libffi_url              := ftp://sourceware.org/pub/libffi/$(libffi).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-debug

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
