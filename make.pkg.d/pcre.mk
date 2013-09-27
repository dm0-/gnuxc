pcre                    := pcre-8.33
pcre_url                := ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$(pcre).tar.bz2

configure-pcre-rule:
	cd $(pcre) && ./$(configure) \
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

build-pcre-rule:
	$(MAKE) -C $(pcre) all

install-pcre-rule: $(call installed,bzip2 zlib readline)
	$(MAKE) -C $(pcre) install \
		pkgconfigdir=/usr/lib/pkgconfig
