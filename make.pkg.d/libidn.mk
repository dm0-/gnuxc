libidn                  := libidn-1.28
libidn_url              := http://ftp.gnu.org/gnu/libidn/$(libidn).tar.gz

prepare-libidn-rule:
# It needs to rebuild doc/Makefile with system aclocal etc.
	$(TOUCH) -r $(libidn)/configure.ac $(libidn)/configure
	$(EDIT) /AM_GNU_GETTEXT_VERSION/d $(libidn)/configure.ac
	$(TOUCH) -r $(libidn)/configure $(libidn)/configure.ac
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
