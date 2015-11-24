gcc                     := gcc-5.2.0
gcc_url                 := http://ftpmirror.gnu.org/gcc/$(gcc)/$(gcc).tar.bz2

ifeq ($(host),$(build))
export AR     = gcc-ar
export CC     = gcc -march=$(arch) -mtune=$(firstword $(tune) generic)
export CXX    = g++ -march=$(arch) -mtune=$(firstword $(tune) generic)
export NM     = gcc-nm
export RANLIB = gcc-ranlib
else
export AR     = $(host)-gcc-ar
export CC     = $(host)-gcc -march=$(arch) -mtune=$(firstword $(tune) generic)
export CXX    = $(host)-g++ -march=$(arch) -mtune=$(firstword $(tune) generic)
export NM     = $(host)-gcc-nm
export RANLIB = $(host)-gcc-ranlib
endif

$(prepare-rule):
	$(call apply,no-add-needed update-isl)
	$(call drop-rpath,libgfortran/configure libgomp/configure,ltmain.sh)
	$(EDIT) '/^ *target_header_dir=/s,=.*,=$(sysroot)/usr/include,' $(builddir)/gcc/configure

$(configure-rule): CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
$(configure-rule):
	$(MKDIR) $(builddir)/build && cd $(builddir)/build && ../$(configure) \
		--disable-libcilkrts \
		--disable-multilib \
		--disable-plugin \
		--enable-__cxa_atexit \
		--enable-clocale=gnu \
		--enable-gnu-unique-object \
		--enable-languages=c,c++,objc,obj-c++,fortran \
		--enable-libgomp \
		--enable-linker-build-id \
		--enable-lto \
		--enable-objc-gc \
		--enable-shared \
		--enable-threads=posix \
		--with-arch=$(arch) \
		--with-cloog --disable-cloog-version-check \
		--with-gxx-include-dir='/usr/include/c++' \
		--with-isl=$(sysroot) --disable-isl-version-check \
		--with-native-system-header-dir='/usr/include' \
		--with-system-zlib \
		--without-included-gettext \
		--without-newlib

$(build-rule):
	$(MAKE) -C $(builddir)/build all

$(install-rule): $$(call installed,binutils cloog mpc)
	$(MAKE) -C $(builddir)/build install
	$(SYMLINK) gcc $(DESTDIR)/usr/bin/cc
