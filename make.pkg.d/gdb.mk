gdb                     := gdb-7.8.1
gdb_url                 := http://ftpmirror.gnu.org/gdb/$(gdb).tar.xz

prepare-gdb-rule:
# Specify Python settings without requiring a python executable.
	$(EDIT) $(gdb)/gdb/configure \
		-e 's,\(python_includes\)=.*,\1=`$(PKG_CONFIG) --cflags python3`,' \
		-e 's,\(python_libs\)=.*,\1=`$(PKG_CONFIG) --libs python3`,' \
		-e 's,\(python_prefix\)=.*,\1=`$(PKG_CONFIG) --variable=exec_prefix python3`,'

configure-gdb-rule:
	cd $(gdb) && ./$(configure) \
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
		--with-guile \
		--with-lzma \
		--with-python='$(PYTHON)' \
		--with-system-gdbinit='/etc/gdbinit' \
		--with-system-readline \
		--with-x \
		--with-zlib \
		--without-included-regex

build-gdb-rule: export ac_cv_guild_program_name = /usr/bin/guild
build-gdb-rule: export ac_cv_path_pkg_config_prog_path = $(PKG_CONFIG)
build-gdb-rule:
	$(MAKE) -C $(gdb) all

install-gdb-rule: $(call installed,guile python)
	$(MAKE) -C $(gdb) install
