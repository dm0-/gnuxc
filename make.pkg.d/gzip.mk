gzip                    := gzip-1.6
gzip_url                := http://ftpmirror.gnu.org/gzip/$(gzip).tar.xz

configure-gzip-rule:
	cd $(gzip) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-silent-rules \
		--disable-rpath \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix

build-gzip-rule:
	$(MAKE) -C $(gzip) all

install-gzip-rule: $(call installed,coreutils)
	$(MAKE) -C $(gzip) install
