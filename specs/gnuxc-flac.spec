%?gnuxc_package_header

Name:           gnuxc-flac
Version:        1.3.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD and GPLv2+ and GFDL
URL:            http://xiph.org/flac/
Source0:        http://downloads.xiph.org/releases/flac/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-libogg-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gcc-c++

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.

%package static
Summary:        Static libraries of %{name}
Requires:       %{name}-devel = %{version}-%{release}

%description static
The %{name}-static package contains the %{gnuxc_name} static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.


%prep
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-oggtest \
    --disable-rpath \
    --disable-werror \
    --enable-altivec \
    --enable-asm-optimizations \
    --enable-cpplibs \
    --enable-debug \
    --enable-ogg \
    --enable-sse \
    --enable-stack-smash-protection \
    --enable-static \
    --with-ogg=%{gnuxc_prefix} \
    \
    --disable-xmms-plugin
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{,meta}flac

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libFLAC{,++}.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libFLAC.so.8
%{gnuxc_libdir}/libFLAC.so.8.3.0
%{gnuxc_libdir}/libFLAC++.so.6
%{gnuxc_libdir}/libFLAC++.so.6.3.0
%doc AUTHORS README
%license COPYING.FDL COPYING.GPL COPYING.LGPL COPYING.Xiph

%files devel
%{gnuxc_includedir}/FLAC
%{gnuxc_includedir}/FLAC++
%{gnuxc_libdir}/libFLAC.so
%{gnuxc_libdir}/libFLAC++.so
%{gnuxc_libdir}/pkgconfig/flac.pc
%{gnuxc_libdir}/pkgconfig/flac++.pc

%files static
%{gnuxc_libdir}/libFLAC.a
%{gnuxc_libdir}/libFLAC++.a
