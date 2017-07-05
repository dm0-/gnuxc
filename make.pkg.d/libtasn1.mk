libtasn1                := libtasn1-4.12
libtasn1_sha1           := f9a05b3b8acf319d89f07267407c03b184c4e3b0
libtasn1_url            := http://ftpmirror.gnu.org/libtasn1/$(libtasn1).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-gcc-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
