%?gnuxc_package_header

Name:           gnuxc-libvpx
Version:        1.6.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.webmproject.org/
Source0:        http://storage.googleapis.com/downloads.webmproject.org/releases/webm/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-gcc-c++

BuildRequires:  perl-Getopt-Long

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
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_env
CROSS='%{gnuxc_host}-' ./configure \
    --disable-docs \
    --disable-install-bins \
    \
    --target=generic-gnu \
    --prefix='%{gnuxc_prefix}' \
    --enable-debug \
    --enable-error-concealment \
    --enable-extra-warnings \
    --enable-internal-stats \
    --enable-multi-res-encoding \
    --enable-onthefly-bitpacking \
    --enable-pic \
    --enable-{,vp9-}{postproc,temporal-denoising} \
    --enable-shared \
    --enable-vp{8,9} \
    --enable-vp9-highbitdepth \
    --enable-webm-io \
    \
    --disable-libyuv \
    --disable-unit-tests
%gnuxc_make %{?_smp_mflags} all V=1

%install
%gnuxc_make_install V=1

# This link is overkill.
rm -f %{buildroot}%{gnuxc_libdir}/libvpx.so.4.1


%files
%{gnuxc_libdir}/libvpx.so.4
%{gnuxc_libdir}/libvpx.so.4.1.0
%doc AUTHORS CHANGELOG README
%license LICENSE PATENTS

%files devel
%{gnuxc_includedir}/vpx
%{gnuxc_libdir}/libvpx.so
%{gnuxc_libdir}/pkgconfig/vpx.pc

%files static
%{gnuxc_libdir}/libvpx.a
