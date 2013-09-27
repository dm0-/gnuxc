gdb                     := gdb-7.6.1
gdb_url                 := http://ftp.gnu.org/gnu/gdb/$(gdb).tar.bz2

prepare-gdb-rule:
	$(PATCH) -d $(gdb) < $(patchdir)/$(gdb)-fix-mig.patch

configure-gdb-rule:
	cd $(gdb) && ./$(configure) \
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
		--with-lzma \
		--with-system-gdbinit='/etc/gdbinit' \
		--with-system-readline \
		--with-x \
		--with-zlib \
		--without-included-regex

build-gdb-rule:
	$(MAKE) -C $(gdb) all

install-gdb-rule: $(call installed,readline xz zlib)
	$(MAKE) -C $(gdb) install
