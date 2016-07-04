libffi                  := libffi-3.2.1
libffi_sha1             := 280c265b789e041c02e5c97815793dfc283fb1e6
libffi_url              := ftp://sourceware.org/pub/libffi/$(libffi).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-debug

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
