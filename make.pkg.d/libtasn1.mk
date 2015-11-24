libtasn1                := libtasn1-4.7
libtasn1_url            := http://ftpmirror.gnu.org/libtasn1/$(libtasn1).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-gcc-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
