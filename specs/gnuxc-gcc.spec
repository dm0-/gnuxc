%if 0%{?_with_bootstrap:1}
%global bootstrap 1
%endif

%if ! 0%{?bootstrap}
%undefine _binaries_in_noarch_packages_terminate_build
%global __gnuxc_path ^%{gnuxc_root}/
%global __elf_exclude_path ^(%{?__elf_exclude_path}|%{gnuxc_root}/.*)$
%global __libsymlink_exclude_path ^(%{?__libsymlink_exclude_path}|%{gnuxc_root}/.*)$
%endif

# Use the same GCC multiarch directory structure as Fedora.
%global gcc_libdir %{_prefix}/lib

Name:           gnuxc-gcc
Version:        7.1.0
Release:        1.%{?bootstrap:0}%{!?bootstrap:1}%{?dist}
Summary:        Cross-compiler for C for pure GNU systems

License:        GPLv3+ and GPLv3+ with exceptions and GPLv2+ with exceptions
URL:            http://www.gnu.org/software/gcc/
Source0:        http://ftpmirror.gnu.org/gcc/gcc-%{version}/%{gnuxc_name}-%{version}.tar.bz2

Patch101:       %{gnuxc_name}-%{version}-no-add-needed.patch

BuildRequires:  gnuxc-binutils
%if ! 0%{?bootstrap}
BuildRequires:  gnuxc-gc-devel
%endif

BuildRequires:  bison
BuildRequires:  cloog-devel
BuildRequires:  flex
BuildRequires:  gettext
BuildRequires:  libmpc-devel
BuildRequires:  libgomp
BuildRequires:  zlib-devel
%if ! 0%{?bootstrap}
BuildRequires:  python-devel
%endif

Requires:       gnuxc-binutils
Requires:       gnuxc-cpp = %{version}-%{release}
%if ! 0%{?bootstrap}
Requires:       gnuxc-libatomic = %{version}-%{release}
Requires:       gnuxc-libgcc = %{version}-%{release}
Requires:       gnuxc-libgomp = %{version}-%{release}
Requires:       gnuxc-libssp = %{version}-%{release}
Requires:       gnuxc-glibc-devel
Provides:       gnuxc-libatomic-devel = %{version}-%{release}
Provides:       gnuxc-libgcc-devel = %{version}-%{release}
Provides:       gnuxc-libgomp-devel = %{version}-%{release}
Provides:       gnuxc-libssp-devel = %{version}-%{release}
Provides:       gnuxc(bootstrapped)
%endif
Provides:       bundled(libiberty)

%if 0%{?bootstrap}
Provides:       gnuxc-bootstrap(%{gnuxc_name}) = %{version}-%{release}
%else
Obsoletes:      gnuxc-bootstrap(%{gnuxc_name}) <= %{version}-%{release}
%endif

%description
Cross-compiler for C for pure GNU systems.

%package -n gnuxc-cpp
Summary:        Cross-compiler version of a C preprocessor for pure GNU systems
Requires:       gnuxc-filesystem

%description -n gnuxc-cpp
Cross-compiler version of a C preprocessor for pure GNU systems.

%if ! 0%{?bootstrap}
%package c++
Summary:        Cross-compiler for C++ for pure GNU systems
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libstdc++ = %{version}-%{release}
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
Summary:        Cross-compiled version of libatomic for the GNU system
BuildArch:      noarch

%description -n gnuxc-libatomic
Cross-compiled version of libatomic for the GNU system.

%package -n gnuxc-libgcc
Summary:        Cross-compiled version of libgcc for the GNU system
BuildArch:      noarch

%description -n gnuxc-libgcc
Cross-compiled version of libgcc for the GNU system.

%package -n gnuxc-libgfortran
Summary:        Cross-compiled version of libgfortran for the GNU system
BuildArch:      noarch

%description -n gnuxc-libgfortran
Cross-compiled version of libgfortran for the GNU system.

%package -n gnuxc-libgomp
Summary:        Cross-compiled version of libgomp for the GNU system
BuildArch:      noarch

%description -n gnuxc-libgomp
Cross-compiled version of libgomp for the GNU system.

%package -n gnuxc-libitm
Summary:        Cross-compiled version of libitm for the GNU system
BuildArch:      noarch

%description -n gnuxc-libitm
Cross-compiled version of libitm for the GNU system.

%package -n gnuxc-libitm-devel
Summary:        Development files for gnuxc-libitm
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libitm = %{version}-%{release}
BuildArch:      noarch

%description -n gnuxc-libitm-devel
The gnuxc-libitm-devel package contains libraries and header files for
applications that use libitm on GNU systems.

%package -n gnuxc-libobjc
Summary:        Cross-compiled version of libobjc for the GNU system
BuildArch:      noarch

%description -n gnuxc-libobjc
Cross-compiled version of libobjc for the GNU system.

%package -n gnuxc-libobjc_gc
Summary:        Cross-compiled version of libobjc_gc for the GNU system
BuildArch:      noarch

%description -n gnuxc-libobjc_gc
Cross-compiled version of libobjc_gc for the GNU system.

%package -n gnuxc-libobjc_gc-devel
Summary:        Development files for gnuxc-libobjc_gc
Requires:       %{name}-objc = %{version}-%{release}
Requires:       gnuxc-libobjc_gc = %{version}-%{release}
BuildArch:      noarch

%description -n gnuxc-libobjc_gc-devel
The gnuxc-libobjc_gc-devel package contains libraries and header files for
applications that use libobjc_gc on GNU systems.

%package -n gnuxc-libquadmath
Summary:        Cross-compiled version of libquadmath for the GNU system
BuildArch:      noarch

%description -n gnuxc-libquadmath
Cross-compiled version of libquadmath for the GNU system.

%package -n gnuxc-libquadmath-devel
Summary:        Development files for gnuxc-libquadmath
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libquadmath = %{version}-%{release}
BuildArch:      noarch

%description -n gnuxc-libquadmath-devel
The gnuxc-libquadmath-devel package contains libraries and header files for
applications that use libquadmath on GNU systems.

%package -n gnuxc-libssp
Summary:        Cross-compiled version of libssp for the GNU system
BuildArch:      noarch

%description -n gnuxc-libssp
Cross-compiled version of libssp for the GNU system.

%package -n gnuxc-libstdc++
Summary:        Cross-compiled version of libstdc++ for the GNU system
BuildArch:      noarch

%description -n gnuxc-libstdc++
Cross-compiled version of libstdc++ for the GNU system.
%endif


%prep
%setup -q -n %{gnuxc_name}-%{version}
%patch101

# Work around a bad hard-coded setting that breaks all cross-compiling.
sed -i -e '/system_bdw_gc_found=no/s/=no/=yes/g' libobjc/configure{.ac,}

# Provide non-conflicting internationalized messages.
sed -i -e 's/"gcc"/"gnuxc-gcc"/' gcc/intl.c
sed -i -e 's,/gcc.mo,/gnuxc-gcc.mo,' gcc/Makefile.in
sed -i -e "s/^#define PACKAGE \"/&gnuxc-/" libcpp/configure
sed -i -e 's,/\$(PACKAGE).mo,/gnuxc-$(PACKAGE).mo,' libcpp/Makefile.in

%build
%global _configure ../configure
%global _program_prefix %{gnuxc_target}-
export C{,XX}FLAGS_FOR_TARGET='%{gnuxc_optflags}'
flags='%{optflags}'
export C{,XX}FLAGS="${flags/ -Werror=format-security / }"
unset flags
mkdir -p build && pushd build
%configure \
    --target=%{gnuxc_target} \
    --libdir=%{gcc_libdir} \
    --with-sysroot=%{gnuxc_sysroot} \
    \
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
    --with-arch=%{gnuxc_arch} \
    --with-cloog --disable-cloog-version-check \
    --with-diagnostics-color=auto \
    --with-gxx-include-dir=%{gnuxc_includedir}/c++ \
    --with-isl= --disable-isl-version-check \
    --with-native-system-header-dir=%{_includedir} \
    --with-system-zlib \
    --without-included-gettext \
    --without-newlib \
    \
%if 0%{?bootstrap}
    --enable-languages=c \
    --disable-decimal-float \
    --disable-libgomp \
    --disable-shared \
    --disable-threads \
    --with-newlib \
%endif
    \
    --enable-dependency-tracking #55930
popd
unset CFLAGS CXXFLAGS FFLAGS FCFLAGS LDFLAGS
%if 0%{?bootstrap}
make -C build %{?_smp_mflags} all-gcc all-target-libgcc \
%else
make -C build %{?_smp_mflags} all \
%endif
    CFLAGS_FOR_TARGET="${CFLAGS_FOR_TARGET/ -Wp,-D_FORTIFY_SOURCE=? / }" \
    CXXFLAGS_FOR_TARGET="${CXXFLAGS_FOR_TARGET/ -Wp,-D_FORTIFY_SOURCE=? / }"

%install
%if 0%{?bootstrap}
make -C build install-gcc install-target-libgcc DESTDIR=%{buildroot}
%else
%make_install -C build

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 755 %{buildroot}%{gnuxc_root}/lib/libgcc_s.so.1

# Link some problematic libraries where the linker can find them.
mkdir -p %{buildroot}%{gnuxc_libdir}
ln -s ../../../lib/libgomp.so.1 %{buildroot}%{gnuxc_libdir}/
ln -s ../../../lib/libstdc++.so.6 %{buildroot}%{gnuxc_libdir}/

# These files conflict with existing installed files.
rm -rf %{buildroot}%{_datadir}/gcc-%{version}
%endif

# We don't need libtool's help.
find %{buildroot} -type f -name 'lib*.la' -delete

# These files conflict with existing installed files.
rm -rf %{buildroot}%{_infodir} %{buildroot}%{_mandir}/man7
rm -f %{buildroot}%{gcc_libdir}/libiberty.a

%find_lang %{name}
%if ! 0%{?bootstrap}
%find_lang gnuxc-cpplib

# Drop cross-compiled library translations.
rm -f %{buildroot}%{_datadir}/locale/{de,fr}/LC_MESSAGES/libstdc++.mo
%endif


%files -f %{name}.lang
%{_bindir}/%{gnuxc_target}-gcc
%{_bindir}/%{gnuxc_target}-gcc-%{version}
%{_bindir}/%{gnuxc_target}-gcc-ar
%{_bindir}/%{gnuxc_target}-gcc-nm
%{_bindir}/%{gnuxc_target}-gcc-ranlib
%{_bindir}/%{gnuxc_target}-gcov
%{_bindir}/%{gnuxc_target}-gcov-dump
%{_bindir}/%{gnuxc_target}-gcov-tool
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtbegin.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtbeginS.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtbeginT.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtend.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtendS.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtfastmath.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtprec32.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtprec64.o
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/crtprec80.o
%dir %{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/*intrin.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/cpuid.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/cross-stdarg.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/float.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/gcov.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/iso646.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/mm3dnow.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/mm_malloc.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdalign.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdarg.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdatomic.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdbool.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stddef.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdfix.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdint-gcc.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdint.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/stdnoreturn.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/unwind.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/varargs.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include-fixed
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/install-tools
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/libgcc.a
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/libgcov.a
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/collect2
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/install-tools
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/liblto_plugin.so
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/liblto_plugin.so.0
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/liblto_plugin.so.0.0.0
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/lto-wrapper
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/lto1
%{_mandir}/man1/%{gnuxc_target}-gcc.1.gz
%{_mandir}/man1/%{gnuxc_target}-gcov.1.gz
%{_mandir}/man1/%{gnuxc_target}-gcov-dump.1.gz
%{_mandir}/man1/%{gnuxc_target}-gcov-tool.1.gz
%if ! 0%{?bootstrap}
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/libgcc_eh.a
%{gnuxc_root}/lib/libgomp.spec
%{gnuxc_root}/lib/libitm.spec
# gnuxc-libatomic-devel
%{gnuxc_root}/lib/libatomic.a
%{gnuxc_root}/lib/libatomic.so
# gnuxc-libgcc-devel
%{gnuxc_root}/lib/libgcc_s.so
# gnuxc-libgomp-devel
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/omp.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/openacc.h
%{gnuxc_root}/lib/libgomp.a
%{gnuxc_root}/lib/libgomp.so
# gnuxc-libssp-devel
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/ssp
%{gnuxc_root}/lib/libssp.a
%{gnuxc_root}/lib/libssp.so
%{gnuxc_root}/lib/libssp_nonshared.a
%endif
%doc gcc/ChangeLog* gcc/FSFChangeLog* gcc/ONEWS
%license gcc/COPYING*

%files %{!?bootstrap:-f gnuxc-cpplib.lang} -n gnuxc-cpp
%{_bindir}/%{gnuxc_target}-cpp
%dir %{gcc_libdir}/gcc/%{gnuxc_target}
%dir %{gcc_libdir}/gcc/%{gnuxc_target}/%{version}
%dir %{_libexecdir}/gcc/%{gnuxc_target}
%dir %{_libexecdir}/gcc/%{gnuxc_target}/%{version}
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/cc1
%{_mandir}/man1/%{gnuxc_target}-cpp.1.gz
%doc libcpp/ChangeLog

%if ! 0%{?bootstrap}
%files c++
%{_bindir}/%{gnuxc_target}-g++
%{_bindir}/%{gnuxc_target}-c++
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/cc1plus
%{_mandir}/man1/%{gnuxc_target}-g++.1.gz
%{gnuxc_includedir}/c++
# gnuxc-libstdc++-devel
%{gnuxc_root}/lib/libstdc++.a
%{gnuxc_root}/lib/libstdc++.so
%{gnuxc_root}/lib/libstdc++fs.a
%{gnuxc_root}/lib/libsupc++.a
%doc gcc/cp/ChangeLog* gcc/cp/NEWS

%files objc
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/objc
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
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/libcaf_single.a
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/finclude
%{_libexecdir}/gcc/%{gnuxc_target}/%{version}/f951
%{_mandir}/man1/%{gnuxc_target}-gfortran.1.gz
%{gnuxc_root}/lib/libgfortran.spec
# gnuxc-libgfortran-devel
%{gnuxc_root}/lib/libgfortran.a
%{gnuxc_root}/lib/libgfortran.so
%doc gcc/fortran/ChangeLog*

%files -n gnuxc-libatomic
%{gnuxc_root}/lib/libatomic.so.1
%{gnuxc_root}/lib/libatomic.so.1.2.0
%doc libatomic/ChangeLog

%files -n gnuxc-libgcc
%{gnuxc_root}/lib/libgcc_s.so.1
%doc libgcc/ChangeLog

%files -n gnuxc-libgfortran
%{gnuxc_root}/lib/libgfortran.so.4
%{gnuxc_root}/lib/libgfortran.so.4.0.0
%doc libgfortran/ChangeLog*

%files -n gnuxc-libgomp
%{gnuxc_root}/lib/libgomp.so.1
%{gnuxc_root}/lib/libgomp.so.1.0.0
%{gnuxc_libdir}/libgomp.so.1
%doc libgomp/ChangeLog*

%files -n gnuxc-libitm
%{gnuxc_root}/lib/libitm.so.1
%{gnuxc_root}/lib/libitm.so.1.0.0
%doc libitm/ChangeLog

%files -n gnuxc-libitm-devel
%{gnuxc_root}/lib/libitm.a
%{gnuxc_root}/lib/libitm.so

%files -n gnuxc-libobjc
%{gnuxc_root}/lib/libobjc.so.4
%{gnuxc_root}/lib/libobjc.so.4.0.0
%doc libobjc/ChangeLog libobjc/README libobjc/THREADS

%files -n gnuxc-libobjc_gc
%{gnuxc_root}/lib/libobjc_gc.so.4
%{gnuxc_root}/lib/libobjc_gc.so.4.0.0

%files -n gnuxc-libobjc_gc-devel
%{gnuxc_root}/lib/libobjc_gc.a
%{gnuxc_root}/lib/libobjc_gc.so

%files -n gnuxc-libquadmath
%{gnuxc_root}/lib/libquadmath.so.0
%{gnuxc_root}/lib/libquadmath.so.0.0.0
%doc libquadmath/ChangeLog
%license libquadmath/COPYING.LIB

%files -n gnuxc-libquadmath-devel
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/quadmath.h
%{gcc_libdir}/gcc/%{gnuxc_target}/%{version}/include/quadmath_weak.h
%{gnuxc_root}/lib/libquadmath.a
%{gnuxc_root}/lib/libquadmath.so

%files -n gnuxc-libssp
%{gnuxc_root}/lib/libssp.so.0
%{gnuxc_root}/lib/libssp.so.0.0.0
%doc libssp/ChangeLog

%files -n gnuxc-libstdc++
%{gnuxc_root}/lib/libstdc++.so.6
%{gnuxc_root}/lib/libstdc++.so.6.0.23
%{gnuxc_root}/lib/libstdc++.so.6.0.23-gdb.py
%{gnuxc_root}/lib/libstdc++.so.6.0.23-gdb.pyc
%{gnuxc_root}/lib/libstdc++.so.6.0.23-gdb.pyo
%{gnuxc_libdir}/libstdc++.so.6
%doc libstdc++-v3/ChangeLog* libstdc++-v3/README
%endif
