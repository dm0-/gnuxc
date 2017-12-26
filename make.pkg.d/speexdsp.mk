speexdsp                := speexdsp-1.2rc3
speexdsp_sha1           := 818403a21ec428feb39fe58f6cb6836d595e639b
speexdsp_url            := http://downloads.xiph.org/releases/speex/$(speexdsp).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-examples \
		--enable-sse \
		--with-fft=smallft

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
