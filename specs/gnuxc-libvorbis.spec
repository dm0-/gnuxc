%?gnuxc_package_header

Name:           gnuxc-libvorbis
Version:        1.3.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.vorbis.com/
Source0:        http://downloads.xiph.org/releases/vorbis/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-libogg-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

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
    --disable-docs \
    --disable-examples \
    --disable-oggtest
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libvorbis{,enc,file}.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}


%files
%{gnuxc_libdir}/libvorbis.so.0
%{gnuxc_libdir}/libvorbis.so.0.4.8
%{gnuxc_libdir}/libvorbisenc.so.2
%{gnuxc_libdir}/libvorbisenc.so.2.0.11
%{gnuxc_libdir}/libvorbisfile.so.3
%{gnuxc_libdir}/libvorbisfile.so.3.3.7
%doc AUTHORS CHANGES README
%license COPYING

%files devel
%{gnuxc_includedir}/vorbis
%{gnuxc_libdir}/libvorbis.so
%{gnuxc_libdir}/libvorbisenc.so
%{gnuxc_libdir}/libvorbisfile.so
%{gnuxc_libdir}/pkgconfig/vorbis.pc
%{gnuxc_libdir}/pkgconfig/vorbisenc.pc
%{gnuxc_libdir}/pkgconfig/vorbisfile.pc

%files static
%{gnuxc_libdir}/libvorbis.a
%{gnuxc_libdir}/libvorbisenc.a
%{gnuxc_libdir}/libvorbisfile.a
