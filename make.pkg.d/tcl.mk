tcl                     := tcl-8.6.4
tcl_branch              := $(tcl:tcl-%=tcl%)
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
	$(MAKE) -C $(builddir) install
	test -e $(DESTDIR)/usr/bin/tclsh || $(SYMLINK) tclsh8.6 $(DESTDIR)/usr/bin/tclsh
