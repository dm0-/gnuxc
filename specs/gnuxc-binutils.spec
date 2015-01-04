# Determine whether this package requires a complete GCC.
%if 0%{!?gnuxc_bootstrapped:1}
%global gnuxc_bootstrapped %(test -n "$gnuxc_bootstrapped" && echo $gnuxc_bootstrapped || (rpm --quiet -q gnuxc-glibc && echo 1 || echo 0))
%endif

# (This value is used in the RPM release number in order to ensure the full
# packages are always an upgrade over bootstrapping sub-packages.)

Name:           gnuxc-binutils
Version:        2.25
Release:        1.%{gnuxc_bootstrapped}%{?dist}
Summary:        Cross-compiler version of %{gnuxc_name} for the GNU system

License:        GPLv2+ and LGPLv2+ and GPLv3+ and LGPLv3+
Group:          Development/Tools
URL:            http://www.gnu.org/software/binutils/
Source0:        http://ftpmirror.gnu.org/binutils/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-filesystem
%if 0%{gnuxc_bootstrapped}
BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-zlib-devel
%endif

BuildRequires:  flex
BuildRequires:  bison
BuildRequires:  gettext
BuildRequires:  zlib-devel

Requires:       gnuxc-filesystem
Provides:       bundled(libiberty)

%description
Cross-compiler binutils (utilities like "strip", "as", "ld") which understand
GNU Hurd executables and libraries.

%if 0%{gnuxc_bootstrapped}
%global __elf_magic ELF.*for GNU/Linux
%undefine _binaries_in_noarch_packages_terminate_build

%package libs
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system
Group:          System Environment/Libraries
BuildArch:      noarch

%description libs
Cross-compiled version of %{gnuxc_name} for the GNU system.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name}-libs = %{version}-%{release}
BuildArch:      noarch

%description devel
The %{name}-devel package contains libraries and header files for developing
applications or translators that use Hurd libraries on GNU systems.

%package static
Summary:        Static libraries of %{name}
Group:          Development/Libraries
Requires:       %{name}-devel = %{version}-%{release}
BuildArch:      noarch

%description static
The %{name}-static package contains the static Hurd libraries for -static
linking on GNU systems.  You don't need these, unless you link statically,
which is highly discouraged.
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
    --with-zlib \\\
    --without-included-gettext \\\
    --without-newlib

mkdir -p cross && (pushd cross
%configure %{binutils_configuration} \
    --disable-install-libiberty \
    --disable-shared \
    --target=%{gnuxc_target} \
    --with-sysroot=%{gnuxc_sysroot}
popd)

%if 0%{gnuxc_bootstrapped}
mkdir -p host && (pushd host
%gnuxc_configure %{binutils_configuration} \
    --disable-nls
popd)
%endif

make -C cross %{?_smp_mflags} all
%if 0%{gnuxc_bootstrapped}
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

%if 0%{gnuxc_bootstrapped}
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
%{gnuxc_root}/bin/strip
%{gnuxc_root}/lib/ldscripts
%doc ChangeLog COPYING* MAINTAINERS README*

%if 0%{gnuxc_bootstrapped}
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


%changelog
