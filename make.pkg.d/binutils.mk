binutils                := binutils-2.24
binutils_url            := http://ftp.gnu.org/gnu/binutils/$(binutils).tar.bz2

ifeq ($(host),$(build))
export AR      = ar
export NM      = nm
export OBJCOPY = objcopy
export OBJDUMP = objdump
export RANLIB  = ranlib
else
export AR      = $(host)-ar
export NM      = $(host)-nm
export OBJCOPY = $(host)-objcopy
export OBJDUMP = $(host)-objdump
export RANLIB  = $(host)-ranlib
endif

prepare-binutils-rule:
	$(EDIT) '/^target_header_dir=$$/d' $(binutils)/libiberty/configure{,.ac}

configure-binutils-rule:
	cd $(binutils) && ./$(configure) \
		--disable-cloog-version-check \
		--disable-isl-version-check \
		--disable-rpath \
		--enable-build-warnings --disable-werror \
		--enable-gold \
		--enable-install-libiberty='/usr/include' \
		--enable-ld=default \
		--enable-libada \
		--enable-libquadmath \
		--enable-libstdcxx \
		--enable-libssp \
		--enable-lto \
		--enable-objc-gc \
		--enable-plugins \
		--enable-shared \
		--enable-threads \
		--with-zlib \
		--without-included-gettext \
		--without-newlib

build-binutils-rule:
	$(MAKE) -C $(binutils) all

install-binutils-rule: $(call installed,zlib)
	$(MAKE) -C $(binutils) install
	$(RM) --recursive $(DESTDIR)/usr/$(host)
