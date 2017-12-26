tcl                     := tcl-8.6.8
tcl_branch              := $(tcl:tcl-%=tcl%)
tcl_sha1                := e13199c76a7d1eae02f35cc9a20fabded6f815f5
tcl_url                 := http://prdownloads.sourceforge.net/tcl/$(tcl:tcl-%=tcl-core%)-src.tar.gz

export TCLSH = /usr/bin/tclsh

$(prepare-rule):
# Correct installed library permissions.
	$(EDIT) '/INSTALL_STUB_LIB=/s/LIBRARY/DATA/' $(builddir)/unix/tcl.m4
	$(EDIT) '/chmod 555/d' $(builddir)/unix/Makefile.in
	$(AUTOGEN) $(builddir)/unix

$(configure-rule):
	cd $(builddir) && unix/$(configure) \
		--disable-rpath \
		--enable-dll-unloading \
		--enable-langinfo \
		--enable-load \
		--enable-man-symlinks \
		--enable-shared \
		--enable-symbols \
		--enable-threads \
		--with-encoding=utf-8 \
		--without-tzdata \
		\
		--disable-64bit \
		--disable-64bit-vis

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install install-private-headers
	test -e $(DESTDIR)/usr/bin/tclsh || $(SYMLINK) tclsh8.6 $(DESTDIR)/usr/bin/tclsh
