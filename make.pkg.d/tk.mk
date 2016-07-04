tk                      := tk-8.6.5
tk_branch               := $(tk:tk-%=tk%)
tk_sha1                 := e63f9e46cfd4ea37799554b003958b54b51dc347
tk_url                  := http://prdownloads.sourceforge.net/tcl/$(tk_branch)-src.tar.gz

export WISH = /usr/bin/wish

$(prepare-rule):
# Use an appropriate pkg-config.
	$(EDIT) '/_\(CFLAG\|LIB\)S=/s,pkg-config,$(PKG_CONFIG),' $(builddir)/unix/configure.in
# Correct installed library permissions.
	$(EDIT) '/INSTALL_STUB_LIB=/s/LIBRARY/DATA/' $(builddir)/unix/tcl.m4
	$(EDIT) '/chmod 555/d' $(builddir)/unix/Makefile.in
	$(AUTOGEN) $(builddir)/unix

$(configure-rule):
	cd $(builddir) && unix/$(configure) \
		--disable-rpath \
		--enable-load \
		--enable-man-symlinks \
		--enable-shared \
		--enable-symbols \
		--enable-threads \
		--enable-xft \
		--with-tcl='$(sysroot)/usr/lib' \
		--with-x \
		\
		--disable-64bit \
		--disable-64bit-vis \
		--disable-xss

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXft tcl)
	$(MAKE) -C $(builddir) install install-private-headers
	test -e $(DESTDIR)/usr/bin/wish || $(SYMLINK) wish8.6 $(DESTDIR)/usr/bin/wish
