speex                   := speex-1.2.0
speex_sha1              := 18ebc3fa3236b4369509e9439acc32d0e864fa7f
speex_url               := http://downloads.xiph.org/releases/speex/$(speex).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-binaries \
		--enable-sse \
		--enable-vbr \
		--enable-vorbis-psy \
		--with-fft=smallft

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libogg speexdsp)
	$(MAKE) -C $(builddir) install
