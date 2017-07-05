%if 0%{?_with_bootstrap:1}
%global bootstrap 1
%endif

%global _docdir_fmt gnuxc/binutils
%if ! 0%{?bootstrap}
%global __elf_magic ELF.*for GNU/Linux
%undefine _binaries_in_noarch_packages_terminate_build
%endif

Name:           gnuxc-binutils
Version:        2.28
Release:        1.%{?bootstrap:0}%{!?bootstrap:1}%{?dist}
Summary:        Cross-compiler version of %{gnuxc_name} for the GNU system

License:        GPLv2+ and LGPLv2+ and GPLv3+ and LGPLv3+
URL:            http://www.gnu.org/software/binutils/
Source0:        http://ftpmirror.gnu.org/binutils/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-filesystem
%if ! 0%{?bootstrap}
BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-zlib-devel
%endif

BuildRequires:  flex
BuildRequires:  bison
BuildRequires:  gettext
BuildRequires:  texinfo
BuildRequires:  zlib-devel

Requires:       gnuxc-filesystem
Provides:       bundled(libiberty)

%if 0%{?bootstrap}
Provides:       gnuxc-bootstrap(%{gnuxc_name}) = %{version}-%{release}
%else
Obsoletes:      gnuxc-bootstrap(%{gnuxc_name}) <= %{version}-%{release}
%endif

%description
Cross-compiler binutils (utilities like "strip", "as", "ld") which understand
GNU Hurd executables and libraries.

%if ! 0%{?bootstrap}
%package libs
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system
BuildArch:      noarch

%description libs
Cross-compiled version of %{gnuxc_name} for the GNU system.

%package devel
Summary:        Development files for %{name}
Requires:       %{name}-libs = %{version}-%{release}
BuildArch:      noarch

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.

%package static
Summary:        Static libraries of %{name}
Requires:       %{name}-devel = %{version}-%{release}
BuildArch:      noarch

%description static
The %{name}-static package contains the %{gnuxc_name} static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.
%endif


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Provide non-conflicting internationalized messages.
for po in bfd binutils gas gold gprof ld opcodes
do
        sed -i -e "s/^#define PACKAGE \"/&gnuxc-/" $po/configure
        sed -i -e "s/^PACKAGE = /&gnuxc-/" $po/po/Make-in
done

%build
%global _configure ../configure
%global _program_prefix %{gnuxc_target}-
%global binutils_configuration \\\
    --disable-cloog-version-check \\\
    --disable-isl-version-check \\\
    --disable-rpath \\\
    --enable-build-warnings --disable-werror \\\
    --enable-deterministic-archives \\\
    --enable-gold \\\
    --enable-install-libiberty='%{gnuxc_includedir}' \\\
    --enable-ld=default \\\
    --enable-libada \\\
    --enable-libquadmath \\\
    --enable-libstdcxx \\\
    --enable-libssp \\\
    --enable-lto \\\
    --enable-objc-gc \\\
    --enable-plugins \\\
    --enable-shared \\\
    --enable-threads \\\
    --with-system-zlib \\\
    --without-included-gettext \\\
    --without-newlib

mkdir -p cross && (pushd cross
%configure %{binutils_configuration} \
    --disable-install-libiberty \
    --disable-shared \
    --target=%{gnuxc_target} \
    --with-sysroot=%{gnuxc_sysroot}
popd)

%if ! 0%{?bootstrap}
mkdir -p host && (pushd host
%gnuxc_configure %{binutils_configuration} \
    --disable-nls
popd)
%endif

make -C cross %{?_smp_mflags} all
%if ! 0%{?bootstrap}
%gnuxc_make -C host %{?_smp_mflags} all-{bfd,libiberty,opcodes}
%endif

%install
%make_install -C cross

# These files conflict with ordinary binutils.
rm -rf %{buildroot}%{_infodir}

# These programs do not exist, so don't install their documentation.
rm -f \
    %{buildroot}%{_mandir}/man1/%{gnuxc_target}-dlltool.1 \
    %{buildroot}%{_mandir}/man1/%{gnuxc_target}-nlmconv.1 \
    %{buildroot}%{_mandir}/man1/%{gnuxc_target}-windmc.1 \
    %{buildroot}%{_mandir}/man1/%{gnuxc_target}-windres.1

%find_lang %{name}
for mo in bfd gas gold gprof ld opcodes
do
        %find_lang gnuxc-$mo
        cat gnuxc-$mo.lang >> %{name}.lang
done

%if ! 0%{?bootstrap}
%gnuxc_make -C host install-{bfd,libiberty,opcodes} DESTDIR=%{buildroot}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/lib{bfd,opcodes}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir}
%endif


%files -f %{name}.lang
%{_bindir}/%{gnuxc_target}-addr2line
%{_bindir}/%{gnuxc_target}-ar
%{_bindir}/%{gnuxc_target}-as
%{_bindir}/%{gnuxc_target}-c++filt
%{_bindir}/%{gnuxc_target}-dwp
%{_bindir}/%{gnuxc_target}-elfedit
%{_bindir}/%{gnuxc_target}-gprof
%{_bindir}/%{gnuxc_target}-ld
%{_bindir}/%{gnuxc_target}-ld.bfd
%{_bindir}/%{gnuxc_target}-ld.gold
%{_bindir}/%{gnuxc_target}-nm
%{_bindir}/%{gnuxc_target}-objcopy
%{_bindir}/%{gnuxc_target}-objdump
%{_bindir}/%{gnuxc_target}-ranlib
%{_bindir}/%{gnuxc_target}-readelf
%{_bindir}/%{gnuxc_target}-size
%{_bindir}/%{gnuxc_target}-strings
%{_bindir}/%{gnuxc_target}-strip
%{_mandir}/man1/%{gnuxc_target}-addr2line.1.gz
%{_mandir}/man1/%{gnuxc_target}-ar.1.gz
%{_mandir}/man1/%{gnuxc_target}-as.1.gz
%{_mandir}/man1/%{gnuxc_target}-c++filt.1.gz
%{_mandir}/man1/%{gnuxc_target}-elfedit.1.gz
%{_mandir}/man1/%{gnuxc_target}-gprof.1.gz
%{_mandir}/man1/%{gnuxc_target}-ld.1.gz
%{_mandir}/man1/%{gnuxc_target}-nm.1.gz
%{_mandir}/man1/%{gnuxc_target}-objcopy.1.gz
%{_mandir}/man1/%{gnuxc_target}-objdump.1.gz
%{_mandir}/man1/%{gnuxc_target}-ranlib.1.gz
%{_mandir}/man1/%{gnuxc_target}-readelf.1.gz
%{_mandir}/man1/%{gnuxc_target}-size.1.gz
%{_mandir}/man1/%{gnuxc_target}-strings.1.gz
%{_mandir}/man1/%{gnuxc_target}-strip.1.gz
%{gnuxc_root}/bin/ar
%{gnuxc_root}/bin/as
%{gnuxc_root}/bin/ld
%{gnuxc_root}/bin/ld.bfd
%{gnuxc_root}/bin/ld.gold
%{gnuxc_root}/bin/nm
%{gnuxc_root}/bin/objcopy
%{gnuxc_root}/bin/objdump
%{gnuxc_root}/bin/ranlib
%{gnuxc_root}/bin/readelf
%{gnuxc_root}/bin/strip
%{gnuxc_root}/lib/ldscripts
%doc binutils/ChangeLog* binutils/MAINTAINERS binutils/NEWS binutils/README
%license COPYING COPYING.LIB COPYING3 COPYING3.LIB

%if ! 0%{?bootstrap}
%files libs
%{gnuxc_libdir}/libbfd-%{version}.so
%{gnuxc_libdir}/libopcodes-%{version}.so

%files devel
%{gnuxc_includedir}/ansidecl.h
%{gnuxc_includedir}/bfd.h
%{gnuxc_includedir}/bfdlink.h
%{gnuxc_includedir}/demangle.h
%{gnuxc_includedir}/dis-asm.h
%{gnuxc_includedir}/dyn-string.h
%{gnuxc_includedir}/fibheap.h
%{gnuxc_includedir}/floatformat.h
%{gnuxc_includedir}/hashtab.h
%{gnuxc_includedir}/libiberty.h
%{gnuxc_includedir}/objalloc.h
%{gnuxc_includedir}/partition.h
%{gnuxc_includedir}/plugin-api.h
%{gnuxc_includedir}/safe-ctype.h
%{gnuxc_includedir}/sort.h
%{gnuxc_includedir}/splay-tree.h
%{gnuxc_includedir}/symcat.h
%{gnuxc_includedir}/timeval-utils.h
%{gnuxc_libdir}/libbfd.so
%{gnuxc_libdir}/libopcodes.so

%files static
%{gnuxc_libdir}/libbfd.a
%{gnuxc_libdir}/libiberty.a
%{gnuxc_libdir}/libopcodes.a
%endif
