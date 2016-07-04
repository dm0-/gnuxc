libtasn1                := libtasn1-4.8
libtasn1_sha1           := a59c9f5db50909bd21ae143da40d74397fd51320
libtasn1_url            := http://ftpmirror.gnu.org/libtasn1/$(libtasn1).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-gcc-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
