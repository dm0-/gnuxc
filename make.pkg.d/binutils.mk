binutils                := binutils-2.25
binutils_url            := http://ftpmirror.gnu.org/binutils/$(binutils).tar.bz2

ifeq ($(host),$(build))
export OBJCOPY = objcopy
export OBJDUMP = objdump
else
export OBJCOPY = $(host)-objcopy
export OBJDUMP = $(host)-objdump
endif

configure-binutils-rule:
	cd $(binutils) && ./$(configure) \
		--disable-cloog-version-check \
		--disable-isl-version-check \
		--disable-rpath \
		--enable-build-warnings --disable-werror \
		--enable-deterministic-archives \
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
