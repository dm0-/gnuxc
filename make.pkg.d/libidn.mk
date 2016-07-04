libidn                  := libidn-1.32
libidn_sha1             := ddd018611b98af7c67d434aa42d15d39f45129f5
libidn_url              := http://ftpmirror.gnu.org/libidn/$(libidn).tar.gz

$(prepare-rule):
# Work around bad prerequisites (due to anti-rpath scripts).
	$(EDIT) '/gdoc:.*configure/s, [^ ]*/configure , ,' $(builddir)/doc/Makefile.in

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
