libidn                  := libidn-1.32
libidn_url              := http://ftpmirror.gnu.org/libidn/$(libidn).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix

$(build-rule):
# Fix targets with configure prerequisite.
	$(TOUCH) $(builddir)/doc/Makefile.gdoc $(builddir)/doc/Makefile.in
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
