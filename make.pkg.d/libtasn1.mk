libtasn1                := libtasn1-4.12
libtasn1_key            := 1F42418905D8206AA754CCDC29EE58B996865171
libtasn1_url            := http://ftpmirror.gnu.org/libtasn1/$(libtasn1).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-gcc-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
