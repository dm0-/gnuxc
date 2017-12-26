%?gnuxc_package_header

Name:           gnuxc-gnutls
Version:        3.6.1
%global mmver   %(v=%{version} ; IFS=. ; v=($v) ; echo -n "${v[*]:0:2}")
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+ and LGPLv2+
URL:            http://www.gnutls.org/
Source0:        ftp://ftp.gnutls.org/gcrypt/gnutls/v%{mmver}/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-guile-devel
BuildRequires:  gnuxc-libidn2-devel
BuildRequires:  gnuxc-libtasn1-devel
BuildRequires:  gnuxc-libunistring-devel
BuildRequires:  gnuxc-nettle-devel
BuildRequires:  gnuxc-p11-kit-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-zlib-devel

BuildRequires:  bison
BuildRequires:  guile-devel

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

# Cross-compiling wants to call libs.
sed -i -e 's/GUILD=.*/GUILD=/' configure

%build
%gnuxc_configure \
    --disable-doc \
    --disable-nls \
    --disable-tools \
    \
    --disable-rpath \
    --disable-{sha1,ssl2,ssl3}-support \
    --enable-cxx \
    --enable-gcc-warnings \
    --enable-guile \
    --enable-openssl-compatibility \
    --enable-static \
    --with-default-trust-store-file=%{gnuxc_sysconfdir}/ssl/ca-bundle.pem \
    --with-idn \
    --with-p11-kit \
    --without-included-libtasn1 \
    --without-included-unistring \
    --without-nettle-mini \
    GUILE_CONFIG=%{_bindir}/%{gnuxc_target}-guile-config \
    \
    --disable-guile \
    --disable-libdane \
    --without-tpm
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f \
    %{buildroot}%{gnuxc_libdir}/libgnutls{,-openssl,xx}.la \
    %{buildroot}%{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.la


%files
#{gnuxc_datadir}/guile/site/2.0/gnutls
#{gnuxc_datadir}/guile/site/2.0/gnutls.scm
#{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.so.0
#{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.so.0.0.0
%{gnuxc_libdir}/libgnutls.so.30
%{gnuxc_libdir}/libgnutls.so.30.20.1
%{gnuxc_libdir}/libgnutls-openssl.so.27
%{gnuxc_libdir}/libgnutls-openssl.so.27.0.2
%{gnuxc_libdir}/libgnutlsxx.so.28
%{gnuxc_libdir}/libgnutlsxx.so.28.1.0
%doc AUTHORS ChangeLog NEWS README.md THANKS
%license doc/COPYING doc/COPYING.LESSER LICENSE

%files devel
%{gnuxc_includedir}/gnutls
#{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.so
%{gnuxc_libdir}/libgnutls.so
%{gnuxc_libdir}/libgnutls-openssl.so
%{gnuxc_libdir}/libgnutlsxx.so
%{gnuxc_libdir}/pkgconfig/gnutls.pc

%files static
#{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.a
%{gnuxc_libdir}/libgnutls.a
%{gnuxc_libdir}/libgnutls-openssl.a
%{gnuxc_libdir}/libgnutlsxx.a
