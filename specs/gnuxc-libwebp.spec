%?gnuxc_package_header

Name:           gnuxc-libwebp
Version:        0.6.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.webmproject.org/
Source0:        http://storage.googleapis.com/downloads.webmproject.org/releases/webp/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-giflib-devel
BuildRequires:  gnuxc-libjpeg-turbo-devel
BuildRequires:  gnuxc-libpng-devel
BuildRequires:  gnuxc-tiff-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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
    --enable-everything \
    --enable-experimental \
    --enable-{gif,jpeg,png,tiff} \
    --enable-libwebp{decoder,demux,extras,mux} \
    --enable-swap-16bit-csp \
    --enable-threading \
    LIBPNG_CONFIG=%{_bindir}/%{gnuxc_target}-libpng-config \
    \
    --enable-asserts \
    \
    --disable-wic \
    --disable-gl # This wants GLUT, not GL.
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{cwebp,dwebp,{gif,img}2webp,webp{info,mux}}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libwebp{,decoder,demux,extras,mux}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libwebp.so.7
%{gnuxc_libdir}/libwebp.so.7.0.1
%{gnuxc_libdir}/libwebpdecoder.so.3
%{gnuxc_libdir}/libwebpdecoder.so.3.0.1
%{gnuxc_libdir}/libwebpdemux.so.2
%{gnuxc_libdir}/libwebpdemux.so.2.0.3
%{gnuxc_libdir}/libwebpmux.so.3
%{gnuxc_libdir}/libwebpmux.so.3.0.1
%doc AUTHORS ChangeLog NEWS README README.mux
%license COPYING PATENTS

%files devel
%{gnuxc_includedir}/webp
%{gnuxc_libdir}/libwebp.so
%{gnuxc_libdir}/libwebpdecoder.so
%{gnuxc_libdir}/libwebpdemux.so
%{gnuxc_libdir}/libwebpmux.so
%{gnuxc_libdir}/pkgconfig/libwebp.pc
%{gnuxc_libdir}/pkgconfig/libwebpdecoder.pc
%{gnuxc_libdir}/pkgconfig/libwebpdemux.pc
%{gnuxc_libdir}/pkgconfig/libwebpmux.pc

%files static
%{gnuxc_libdir}/libwebp.a
%{gnuxc_libdir}/libwebpdecoder.a
%{gnuxc_libdir}/libwebpdemux.a
%{gnuxc_libdir}/libwebpmux.a
