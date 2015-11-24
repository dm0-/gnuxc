binutils                := binutils-2.25.1
binutils_url            := http://ftpmirror.gnu.org/binutils/$(binutils).tar.bz2

ifeq ($(host),$(build))
export OBJCOPY = objcopy
export OBJDUMP = objdump
else
export OBJCOPY = $(host)-objcopy
export OBJDUMP = $(host)-objdump
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,zlib)
	$(MAKE) -C $(builddir) install
	$(RM) --recursive $(DESTDIR)/usr/$(host)
