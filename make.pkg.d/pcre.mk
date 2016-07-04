pcre                    := pcre-8.39
pcre_sha1               := 5e38289fd1b4ef3e8426f31a01e34b6924d80b90
pcre_url                := ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$(pcre).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-silent-rules \
		--enable-pcre16 \
		--enable-pcre32 \
		--enable-jit \
		--enable-unicode-properties \
		--enable-newline-is-any \
		--enable-pcregrep-libz \
		--enable-pcregrep-libbz2 \
		--enable-pcretest-libreadline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bzip2 zlib readline)
	$(MAKE) -C $(builddir) install \
		pkgconfigdir=/usr/lib/pkgconfig
