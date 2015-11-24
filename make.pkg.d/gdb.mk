gdb                     := gdb-7.10
gdb_url                 := http://ftpmirror.gnu.org/gdb/$(gdb).tar.xz

$(prepare-rule):
# Specify Python settings without requiring a python executable.
	$(EDIT) $(builddir)/gdb/configure \
		-e 's,\(python_includes\)=.*,\1=`$(PKG_CONFIG) --cflags python3`,' \
		-e 's,\(python_libs\)=.*,\1=`$(PKG_CONFIG) --libs python3`,' \
		-e 's,\(python_prefix\)=.*,\1=`$(PKG_CONFIG) --variable=exec_prefix python3`,'

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-cloog-version-check \
		--disable-isl-version-check \
		--disable-rpath \
		--disable-sim \
		--enable-{,gdb-}build-warnings --disable-werror \
		--enable-libada \
		--enable-libquadmath \
		--enable-libssp \
		--enable-libstdcxx \
		--enable-lto \
		--enable-objc-gc \
		--enable-plugins \
		--enable-tui \
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
		--with-x \
		--with-zlib \
		--without-included-regex

$(build-rule): private override export ac_cv_guild_program_name = /usr/bin/guild
$(build-rule): private override export ac_cv_path_pkg_config_prog_path = $(PKG_CONFIG)
$(build-rule):
	$(MAKE) -C $(builddir) all
# Refresh the documentation files after building.
	$(MAKE) -C $(builddir)/gdb/doc info man

$(install-rule): $$(call installed,guile python)
	$(MAKE) -C $(builddir) install
