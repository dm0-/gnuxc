pcre2                   := pcre2-10.30
pcre2_key               := 45F68D54BBE23FB3039B46E59766E084FB0F43D8
pcre2_url               := http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$(pcre2).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-pcre2-{8,16,32} \
		--enable-jit \
		--enable-unicode \
		--enable-newline-is-any \
		--enable-pcre2grep-libz \
		--enable-pcre2grep-libbz2 \
		--enable-pcre2test-libreadline \
		\
		$(if $(DEBUG),--enable-debug,--disable-debug)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bzip2 zlib readline)
	$(MAKE) -C $(builddir) install \
		pkgconfigdir=/usr/lib/pkgconfig
