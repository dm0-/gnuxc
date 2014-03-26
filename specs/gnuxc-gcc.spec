%global gnuxc_has_env %(rpm --quiet -q gnuxc-glibc && echo 1 || echo 0)

# (This value is used in the RPM release number in order to ensure the full
# packages are always an upgrade over bootstrapping sub-packages.)

%if 0%{gnuxc_has_env}
%undefine _binaries_in_noarch_packages_terminate_build
%global __gnuxc_path ^%{gnuxc_root}/
%global __elf_exclude_path ^(%{?__elf_exclude_path}|%{gnuxc_root}/.*)$
%global __libsymlink_exclude_path ^(%{?__libsymlink_exclude_path}|%{gnuxc_root}/.*)$
%endif

Name:           gnuxc-gcc
Version:        4.8.2
Release:        1.%{gnuxc_has_env}%{?dist}
Summary:        Cross-compiler for C for pure GNU systems

License:        GPLv3+ and GPLv3+ with exceptions and GPLv2+ with exceptions
Group:          Development/Languages
URL:            http://www.gnu.org/software/gcc/
Source0:        http://ftp.gnu.org/gnu/gcc/gcc-%{version}/%{gnuxc_name}-%{version}.tar.bz2

Patch101:       %{gnuxc_name}-%{version}-no-add-needed.patch

BuildRequires:  gnuxc-binutils
%if 0%{gnuxc_has_env}
BuildRequires:  gnuxc-glibc-devel
%endif

BuildRequires:  bison
BuildRequires:  flex
BuildRequires:  gettext
BuildRequires:  libmpc-devel
BuildRequires:  libgomp
BuildRequires:  zlib-devel
BuildRequires:  ppl ppl-devel
BuildRequires:  cloog-ppl cloog-ppl-devel

Requires:       gnuxc-binutils
Requires:       gnuxc-cpp = %{version}-%{release}
%if 0%{gnuxc_has_env}
Requires:       gnuxc-libatomic = %{version}-%{release}
Requires:       gnuxc-libgcc = %{version}-%{release}
Requires:       gnuxc-libgomp = %{version}-%{release}
Requires:       gnuxc-libssp = %{version}-%{release}
Provides:       gnuxc-libatomic-devel = %{version}-%{release}
Provides:       gnuxc-libgcc-devel = %{version}-%{release}
Provides:       gnuxc-libgomp-devel = %{version}-%{release}
Provides:       gnuxc-libssp-devel = %{version}-%{release}
%endif
Provides:       bundled(libiberty)

%description
Cross-compiler for C for pure GNU systems.
%if 0%{gnuxc_has_env} == 0
This is only a bootstrap version!  Install glibc and rebuild this package.
%endif

%package -n gnuxc-cpp
Summary:        Cross-compiler version of a C preprocessor for pure GNU systems
Requires:       gnuxc-filesystem

%description -n gnuxc-cpp
Cross-compiler version of a C preprocessor for pure GNU systems.

%if 0%{gnuxc_has_env}
%package c++
Summary:        Cross-compiler for C++ for pure GNU systems
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libstdc++ = %{version}-%{release}
Requires:       gnuxc-glibc-devel
Provides:       gnuxc-libstdc++-devel = %{version}-%{release}

%description c++
Cross-compiler for C++ for pure GNU systems.

%package objc
Summary:        Cross-compiler for Objective-C for pure GNU systems
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libobjc = %{version}-%{release}
Provides:       gnuxc-libobjc-devel = %{version}-%{release}

%description objc
Cross-compiler for Objective-C for pure GNU systems.

%package objc++
Summary:        Cross-compiler for Objective-C++ for pure GNU systems
Requires:       %{name}-c++ = %{version}-%{release}
Requires:       %{name}-objc = %{version}-%{release}

%description objc++
Cross-compiler for Objective-C++ for pure GNU systems.

%package gfortran
Summary:        Cross-compiler for FORTRAN for pure GNU systems
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libgfortran = %{version}-%{release}
Provides:       gnuxc-libgfortran-devel = %{version}-%{release}

%description gfortran
Cross-compiler for FORTRAN for pure GNU systems.

%package -n gnuxc-libatomic
Summary:        GNU Atomic library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libatomic
This package contains the GNU Atomic library which is a GCC support runtime
library for atomic operations not supported by hardware for pure GNU systems.

%package -n gnuxc-libgcc
Summary:        GCC shared support library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libgcc
This package contains GCC shared support library which is needed e.g. for
exception handling support for pure GNU systems.

%package -n gnuxc-libgfortran
Summary:        FORTRAN runtime for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libgfortran
This package contains FORTRAN shared support library which is needed to run
FORTRAN dynamically linked programs for pure GNU systems.

%package -n gnuxc-libgomp
Summary:        GCC OpenMP v3.0 shared support library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libgomp
This package contains GCC shared support library which is needed for OpenMP
v3.0 support for pure GNU systems.

%package -n gnuxc-libitm
Summary:        GNU Transactional Memory library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libitm
This package contains the GNU Transactional Memory library which is a GCC
transactional memory support runtime library for pure GNU systems.

%package -n gnuxc-libitm-devel
Summary:        GNU Transactional Memory support for pure GNU systems
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libitm = %{version}-%{release}
BuildArch:      noarch

%description -n gnuxc-libitm-devel
This package contains headers and support files for the GNU Transactional
Memory library for pure GNU systems.

%package -n gnuxc-libmudflap
Summary:        GCC mudflap shared support library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libmudflap
This package contains GCC shared support library which is needed for mudflap
support for pure GNU systems.

%package -n gnuxc-libmudflap-devel
Summary:        GCC mudflap support for pure GNU systems
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libmudflap = %{version}-%{release}
BuildArch:      noarch

%description -n gnuxc-libmudflap-devel
This package contains headers for building mudflap-instrumented programs for
pure GNU systems.

%package -n gnuxc-libobjc
Summary:        Objective-C runtime for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libobjc
This package contains Objective-C shared support library which is needed to run
Objective-C dynamically linked programs for pure GNU systems.

%package -n gnuxc-libobjc_gc
Summary:        Boehm's GC shared support library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libobjc_gc
This package contains shared libraries for programs utilizing Boehm's garbage
collector with the Objective-C runtime for pure GNU systems.

%package -n gnuxc-libobjc_gc-devel
Summary:        Boehm's GC support for pure GNU systems
Group:          Development/Libraries
Requires:       %{name}-objc = %{version}-%{release}
Requires:       gnuxc-libobjc_gc = %{version}-%{release}
BuildArch:      noarch

%description -n gnuxc-libobjc_gc-devel
This package contains files for building programs utilizing Boehm's garbage
collector with the Objective-C runtime for pure GNU systems.

%package -n gnuxc-libquadmath
Summary:        GCC __float128 shared support library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libquadmath
This package contains GCC shared support library which is needed for __float128
math support and for FORTRAN REAL*16 support for pure GNU systems.

%package -n gnuxc-libquadmath-devel
Summary:        GCC __float128 support for pure GNU systems
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libquadmath = %{version}-%{release}
BuildArch:      noarch

%description -n gnuxc-libquadmath-devel
This package contains headers for building Fortran programs using REAL*16 and
programs using __float128 math for pure GNU systems.

%package -n gnuxc-libssp
Summary:        GCC stack protection library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libssp
This package contains GCC stack protection library which is needed for programs
that take buffer overflow precautions for pure GNU systems.

%package -n gnuxc-libstdc++
Summary:        GNU Standard C++ library for pure GNU systems
Group:          System Environment/Libraries
Requires:       gnuxc-filesystem
BuildArch:      noarch

%description -n gnuxc-libstdc++
This package contains Standard C++ shared support library which is needed to
run C++ dynamically linked programs for pure GNU systems.
%endif


%prep
%setup -q -n %{gnuxc_name}-%{version}
%patch101

# Provide non-conflicting internationalized messages.
sed -i -e 's/"gcc"/"gnuxc-gcc"/' gcc/intl.c
sed -i -e 's,/gcc.mo,/gnuxc-gcc.mo,' gcc/Makefile.in
sed -i -e "s/^#define PACKAGE \"/&gnuxc-/" libcpp/configure
sed -i -e 's,/\$(PACKAGE).mo,/gnuxc-$(PACKAGE).mo,' libcpp/Makefile.in

%build
%global _configure ../configure
%global _program_prefix %{gnuxc_target}-
mkdir -p build && pushd build
%configure \
    --target=%{gnuxc_target} \
    --with-sysroot=%{gnuxc_sysroot} \
    \
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
    --with-arch=%{gnuxc_arch} \
    --with-cloog --disable-cloog-version-check \
    --with-gxx-include-dir=%{gnuxc_includedir}/c++ \
    --with-native-system-header-dir=%{_includedir} \
    --with-ppl --disable-ppl-version-check \
    --with-system-zlib \
    --without-included-gettext \
    --without-newlib \
    \
%if 0%{gnuxc_has_env} == 0
    --enable-languages=c \
    --disable-decimal-float \
    --disable-libgomp \
    --disable-lto \
    --disable-shared \
    --disable-threads \
    --with-newlib \
%endif
    \
    --enable-dependency-tracking
popd
unset CFLAGS CXXFLAGS FFLAGS FCFLAGS LDFLAGS
%if 0%{gnuxc_has_env}
make -C build %{?_smp_mflags} all \
%else
make -C build %{?_smp_mflags} all-gcc all-target-libgcc \
%endif
    CFLAGS_FOR_TARGET='%{gnuxc_optflags}' \
    CXXFLAGS_FOR_TARGET='%{gnuxc_optflags}'

%install
%if 0%{gnuxc_has_env}
%make_install -C build

# We don't need libtool's help.
find %{buildroot} -type f -name 'lib*.la' -delete

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 755 %{buildroot}%{gnuxc_root}/lib/libgcc_s.so.1

# These files conflict with existing installed files.
rm -rf %{buildroot}%{_datadir}/gcc-%{version}
%else
make -C build install-gcc install-target-libgcc DESTDIR=%{buildroot}
%endif

# These files conflict with existing installed files.
rm -rf %{buildroot}%{_infodir} %{buildroot}%{_mandir}/man7
rm -f %{buildroot}%{_libdir}/libiberty.a

%find_lang %{name}
%if 0%{gnuxc_has_env}
%find_lang gnuxc-cpplib
rm -f %{buildroot}%{_datadir}/locale/{de,fr}/LC_MESSAGES/libstdc++.mo
%else
touch gnuxc-cpplib.lang
%endif


%files -f %{name}.lang
%{_bindir}/%{gnuxc_target}-gcc
%{_bindir}/%{gnuxc_target}-gcc-%{version}
%{_bindir}/%{gnuxc_target}-gcc-ar
%{_bindir}/%{gnuxc_target}-gcc-nm
%{_bindir}/%{gnuxc_target}-gcc-ranlib
%{_bindir}/%{gnuxc_target}-gcov
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtbegin.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtbeginS.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtbeginT.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtend.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtendS.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtfastmath.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtprec32.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtprec64.o
%{_libdir}/gcc/%{gnuxc_target}/%{version}/crtprec80.o
%dir %{_libdir}/gcc/%{gnuxc_target}/%{version}/include
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/*intrin.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/cpuid.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/cross-stdarg.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/float.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/iso646.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/mm3dnow.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/mm_malloc.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdalign.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdarg.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdbool.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stddef.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdfix.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdint-gcc.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdint.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdnoreturn.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/unwind.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/varargs.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include-fixed
%{_libdir}/gcc/%{gnuxc_target}/%{version}/install-tools
%{_libdir}/gcc/%{gnuxc_target}/%{version}/libgcc.a
%{_libdir}/gcc/%{gnuxc_target}/%{version}/libgcov.a
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/collect2
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/install-tools
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/lto-wrapper
%{_mandir}/man1/%{gnuxc_target}-gcc.1.gz
%{_mandir}/man1/%{gnuxc_target}-gcov.1.gz
%if 0%{gnuxc_has_env}
%{_libdir}/gcc/%{gnuxc_target}/%{version}/libgcc_eh.a
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/lto1
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/liblto_plugin.so
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/liblto_plugin.so.0
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/liblto_plugin.so.0.0.0
%{gnuxc_root}/lib/libgomp.spec
%{gnuxc_root}/lib/libitm.spec
# gnuxc-libatomic-devel
%{gnuxc_root}/lib/libatomic.a
%{gnuxc_root}/lib/libatomic.so
# gnuxc-libgcc-devel
%{gnuxc_root}/lib/libgcc_s.so
# gnuxc-libgomp-devel
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/omp.h
%{gnuxc_root}/lib/libgomp.a
%{gnuxc_root}/lib/libgomp.so
# gnuxc-libssp-devel
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/ssp
%{gnuxc_root}/lib/libssp.a
%{gnuxc_root}/lib/libssp.so
%{gnuxc_root}/lib/libssp_nonshared.a
%endif

%files -f gnuxc-cpplib.lang -n gnuxc-cpp
%{_bindir}/%{gnuxc_target}-cpp
%dir %{_libdir}/gcc/%{gnuxc_target}
%dir %{_libdir}/gcc/%{gnuxc_target}/%{version}
%dir %{_libexecdir}/gcc/%{gnuxc_target}
%dir %{_libexecdir}/gcc/%{gnuxc_target}/%{version}
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/cc1
%{_mandir}/man1/%{gnuxc_target}-cpp.1.gz

%if 0%{gnuxc_has_env}
%files c++
%{_bindir}/%{gnuxc_target}-g++
%{_bindir}/%{gnuxc_target}-c++
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/cc1plus
%{_mandir}/man1/%{gnuxc_target}-g++.1.gz
%{gnuxc_includedir}/c++
# gnuxc-libstdc++-devel
%{gnuxc_root}/lib/libstdc++.a
%{gnuxc_root}/lib/libstdc++.so
%{gnuxc_root}/lib/libsupc++.a
%doc gcc/cp/ChangeLog* gcc/cp/NEWS

%files objc
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/objc
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/cc1obj
# gnuxc-libobjc-devel
%{gnuxc_root}/lib/libobjc.a
%{gnuxc_root}/lib/libobjc.so
%doc gcc/objc/ChangeLog

%files objc++
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/cc1objplus
%doc gcc/objcp/ChangeLog

%files gfortran
%{_bindir}/%{gnuxc_target}-gfortran
%{_libdir}/gcc/%{gnuxc_target}/%{version}/libgfortranbegin.a
%{_libdir}/gcc/%{gnuxc_target}/%{version}/libcaf_single.a
%{_libdir}/gcc/%{gnuxc_target}/%{version}/finclude
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/f951
%{_mandir}/man1/%{gnuxc_target}-gfortran.1.gz
%{gnuxc_root}/lib/libgfortran.spec
# gnuxc-libgfortran-devel
%{gnuxc_root}/lib/libgfortran.a
%{gnuxc_root}/lib/libgfortran.so
%doc gcc/fortran/ChangeLog*

%files -n gnuxc-libatomic
%{gnuxc_root}/lib/libatomic.so.1
%{gnuxc_root}/lib/libatomic.so.1.0.0
%doc libatomic/ChangeLog

%files -n gnuxc-libgcc
%{gnuxc_root}/lib/libgcc_s.so.1
%doc libgcc/ChangeLog

%files -n gnuxc-libgfortran
%{gnuxc_root}/lib/libgfortran.so.3
%{gnuxc_root}/lib/libgfortran.so.3.0.0
%doc libgfortran/ChangeLog*

%files -n gnuxc-libgomp
%{gnuxc_root}/lib/libgomp.so.1
%{gnuxc_root}/lib/libgomp.so.1.0.0
%doc libgomp/ChangeLog*

%files -n gnuxc-libitm
%{gnuxc_root}/lib/libitm.so.1
%{gnuxc_root}/lib/libitm.so.1.0.0
%doc libitm/ChangeLog

%files -n gnuxc-libitm-devel
%{gnuxc_root}/lib/libitm.a
%{gnuxc_root}/lib/libitm.so

%files -n gnuxc-libmudflap
%{gnuxc_root}/lib/libmudflap.so.0
%{gnuxc_root}/lib/libmudflap.so.0.0.0
%{gnuxc_root}/lib/libmudflapth.so.0
%{gnuxc_root}/lib/libmudflapth.so.0.0.0
%doc libmudflap/ChangeLog

%files -n gnuxc-libmudflap-devel
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/mf-runtime.h
%{gnuxc_root}/lib/libmudflap.a
%{gnuxc_root}/lib/libmudflap.so
%{gnuxc_root}/lib/libmudflapth.a
%{gnuxc_root}/lib/libmudflapth.so

%files -n gnuxc-libobjc
%{gnuxc_root}/lib/libobjc.so.4
%{gnuxc_root}/lib/libobjc.so.4.0.0
%doc libobjc/ChangeLog libobjc/README libobjc/THREADS

%files -n gnuxc-libobjc_gc
%{gnuxc_root}/lib/libobjc_gc.so.4
%{gnuxc_root}/lib/libobjc_gc.so.4.0.0
%doc boehm-gc/ChangeLog boehm-gc/doc/README*

%files -n gnuxc-libobjc_gc-devel
%{gnuxc_root}/lib/libobjc_gc.a
%{gnuxc_root}/lib/libobjc_gc.so

%files -n gnuxc-libquadmath
%{gnuxc_root}/lib/libquadmath.so.0
%{gnuxc_root}/lib/libquadmath.so.0.0.0
%doc libquadmath/ChangeLog libquadmath/COPYING.LIB

%files -n gnuxc-libquadmath-devel
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/quadmath.h
%{_libdir}/gcc/%{gnuxc_target}/%{version}/include/quadmath_weak.h
%{gnuxc_root}/lib/libquadmath.a
%{gnuxc_root}/lib/libquadmath.so

%files -n gnuxc-libssp
%{gnuxc_root}/lib/libssp.so.0
%{gnuxc_root}/lib/libssp.so.0.0.0
%doc libssp/ChangeLog

%files -n gnuxc-libstdc++
%{gnuxc_root}/lib/libstdc++.so.6
%{gnuxc_root}/lib/libstdc++.so.6.0.18
%{gnuxc_root}/lib/libstdc++.so.6.0.18-gdb.py
%{gnuxc_root}/lib/libstdc++.so.6.0.18-gdb.pyc
%{gnuxc_root}/lib/libstdc++.so.6.0.18-gdb.pyo
%doc libstdc++-v3/ChangeLog* libstdc++-v3/README
%endif
