gcc                     := gcc-4.9.2
gcc_url                 := http://ftpmirror.gnu.org/gcc/$(gcc)/$(gcc).tar.bz2

ifeq ($(host),$(build))
export AR     = gcc-ar
export CC     = gcc -march=$(arch) -mtune=generic
export CXX    = g++ -march=$(arch) -mtune=generic
export NM     = gcc-nm
export RANLIB = gcc-ranlib
else
export AR     = $(host)-gcc-ar
export CC     = $(host)-gcc -march=$(arch) -mtune=generic
export CXX    = $(host)-g++ -march=$(arch) -mtune=generic
export NM     = $(host)-gcc-nm
export RANLIB = $(host)-gcc-ranlib
endif

prepare-gcc-rule:
	$(PATCH) -d $(gcc) < $(patchdir)/$(gcc)-no-add-needed.patch
	$(PATCH) -d $(gcc) < $(patchdir)/$(gcc)-color-auto.patch
	$(PATCH) -d $(gcc) < $(patchdir)/$(gcc)-update-isl.patch
	$(EDIT) '/^ *target_header_dir=/s,=.*,=$(sysroot)/usr/include,' $(gcc)/gcc/configure
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(gcc)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(gcc)/libgfortran/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(gcc)/libgfortran/configure

configure-gcc-rule: CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
configure-gcc-rule:
	$(MKDIR) $(gcc)/build && cd $(gcc)/build && ../$(configure) \
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

build-gcc-rule:
	$(MAKE) -C $(gcc)/build all

install-gcc-rule: $(call installed,cloog mpc zlib)
	$(MAKE) -C $(gcc)/build install
	$(SYMLINK) gcc $(DESTDIR)/usr/bin/cc
