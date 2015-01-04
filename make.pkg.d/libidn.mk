libidn                  := libidn-1.29
libidn_url              := http://ftpmirror.gnu.org/libidn/$(libidn).tar.gz

prepare-libidn-rule:
	$(RM) $(libidn)/configure

configure-libidn-rule:
	cd $(libidn) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix

build-libidn-rule:
	$(MAKE) -C $(libidn) all

install-libidn-rule: $(call installed,glibc)
	$(MAKE) -C $(libidn) install
