gdb                     := gdb-8.0
gdb_sha1                := 148c8e783ebf9b281241d0566db59961191ec64d
gdb_url                 := http://ftpmirror.gnu.org/gdb/$(gdb).tar.xz

$(prepare-rule):
	$(call apply,update-hurd)
# Don't look for weird TCL header locations.
	$(EDIT) 's,/\(tcl\|tk\)-private/generic,,g' $(builddir)/gdb/configure
# Specify Python settings without requiring a python executable.
	$(EDIT) $(builddir)/gdb/configure \
		-e 's,\(python_includes\)=.*,\1=`$(PKG_CONFIG) --cflags python3`,' \
		-e 's,\(python_libs\)=.*,\1=`$(PKG_CONFIG) --libs python3`,' \
		-e 's,\(python_prefix\)=.*,\1=`$(PKG_CONFIG) --variable=exec_prefix python3`,'
# Avoid dumb name clashes.
	$(EDIT) '1i#define _mach_user_' $(builddir)/gdb/{python/py-record-btrace,thread}.c

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-cloog-version-check \
		--disable-isl-version-check \
		--disable-rpath \
		--disable-sim \
		--enable-{,gdb-}build-warnings --disable-werror \
		--enable-gdbtk \
		--enable-libada \
		--enable-libquadmath \
		--enable-libssp \
		--enable-libstdcxx \
		--enable-lto \
		--enable-objc-gc \
		--enable-plugins \
		--enable-tui \
		--enable-vtable-verify \
		--with-curses \
		--with-cloog \
		--with-expat \
		--with-gmp \
		--with-guile \
		--with-isl='$(sysroot)/usr' \
		--with-lzma \
		--with-mpc \
		--with-mpfr \
		--with-python='$(PYTHON)' \
		--with-system-gdbinit='/etc/gdbinit' \
		--with-system-readline \
		--with-system-zlib \
		--with-tcl='$(sysroot)/usr/lib' \
		--with-tk='$(sysroot)/usr/lib' \
		--with-x \
		--without-included-regex \
		\
		--disable-gdbtk \
		--without-guile # Disable this until Guile 2.2 works.

$(build-rule): private override export ac_cv_guild_program_name = /usr/bin/guild
$(build-rule): private override export ac_cv_path_pkg_config_prog_path = $(PKG_CONFIG)
$(build-rule): private override export CPPFLAGS = -DPATH_MAX=4096
$(build-rule):
	$(MAKE) -C $(builddir) all
# Refresh the documentation files after building.
	$(MAKE) -C $(builddir)/gdb/doc info man

$(install-rule): $$(call installed,guile python)
	$(MAKE) -C $(builddir) install
