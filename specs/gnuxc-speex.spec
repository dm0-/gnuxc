%?gnuxc_package_header

Name:           gnuxc-speex
Version:        1.2.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.speex.org/
Source0:        http://downloads.xiph.org/releases/speex/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-speexdsp-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-speexdsp-devel

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
    --enable-binaries \
    --enable-sse \
    --enable-vbr \
    --enable-vorbis-psy \
    --with-fft=smallft \
    \
    --disable-binaries \
    PKG_CONFIG=%{gnuxc_pkgconfig}
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libspeex.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}


%files
%{gnuxc_libdir}/libspeex.so.1
%{gnuxc_libdir}/libspeex.so.1.5.1
%doc AUTHORS ChangeLog NEWS README TODO
%license COPYING

%files devel
%{gnuxc_includedir}/speex/speex.h
%{gnuxc_includedir}/speex/speex_bits.h
%{gnuxc_includedir}/speex/speex_callbacks.h
%{gnuxc_includedir}/speex/speex_config_types.h
%{gnuxc_includedir}/speex/speex_header.h
%{gnuxc_includedir}/speex/speex_stereo.h
%{gnuxc_includedir}/speex/speex_types.h
%{gnuxc_libdir}/libspeex.so
%{gnuxc_libdir}/pkgconfig/speex.pc

%files static
%{gnuxc_libdir}/libspeex.a
