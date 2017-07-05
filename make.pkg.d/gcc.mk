gcc                     := gcc-7.1.0
gcc_sha1                := 9f1e907f27eadefe7d5f7567c09e17805d9c8837
gcc_url                 := http://ftpmirror.gnu.org/gcc/$(gcc)/$(gcc).tar.bz2

ifeq ($(host),$(build))
export AR     = gcc-ar
export CC     = gcc -march=$(arch) -mtune=$(or $(tune),generic)
export CXX    = g++ -march=$(arch) -mtune=$(or $(tune),generic)
export F77    = gfortran -march=$(arch) -mtune=$(or $(tune),generic)
export FC     = $(F77)
export NM     = gcc-nm
export RANLIB = gcc-ranlib
else
export AR     = $(host)-gcc-ar
export CC     = $(host)-gcc -march=$(arch) -mtune=$(or $(tune),generic)
export CXX    = $(host)-g++ -march=$(arch) -mtune=$(or $(tune),generic)
export F77    = $(host)-gfortran -march=$(arch) -mtune=$(or $(tune),generic)
export FC     = $(F77)
export NM     = $(host)-gcc-nm
export RANLIB = $(host)-gcc-ranlib
endif

$(prepare-rule):
	$(call apply,no-add-needed)
	$(EDIT) '/^ *target_header_dir=/s,=.*,=$(sysroot)/usr/include,' $(builddir)/gcc/configure
# Work around a bad hard-coded setting that breaks all cross-compiling.
	$(EDIT) '/system_bdw_gc_found=no/s/=no/=yes/g' $(builddir)/libobjc/configure{.ac,}

$(configure-rule): CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=) -Wno-error=format-security
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
		--with-diagnostics-color=auto \
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
