%?gnuxc_package_header

Name:           gnuxc-gnutls
Version:        3.4.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+ and LGPLv2.1+ and LGPLv3+
Group:          System Environment/Libraries
URL:            http://www.gnutls.org/
Source0:        ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-guile-devel
BuildRequires:  gnuxc-libidn-devel
BuildRequires:  gnuxc-libtasn1-devel
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
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.

%package static
Summary:        Static libraries of %{name}
Group:          Development/Libraries
Requires:       %{name}-devel = %{version}-%{release}

%description static
The %{name}-static package contains the %{gnuxc_name} static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Seriously disable rpaths.
sed -i -e 's/\(need_relink\)=yes/\1=no/' build-aux/ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__BAD_LIBTOOL__/' configure

%build
%gnuxc_configure \
    --disable-doc \
    --disable-nls \
    --disable-tools \
    \
    --disable-openssl-compatibility \
    --disable-rpath \
    --disable-silent-rules \
    --enable-cxx \
    --enable-gcc-warnings \
    --enable-guile \
    --enable-static \
    --with-default-trust-store-file=%{gnuxc_sysconfdir}/ssl/ca-bundle.pem \
    --with-idn \
    --with-p11-kit \
    --with-zlib \
    --without-included-libtasn1 \
    --without-nettle-mini \
    GUILE_CONFIG=%{_bindir}/%{gnuxc_target}-guile-config \
    \
    --disable-libdane \
    --without-tpm
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f \
    %{buildroot}%{gnuxc_libdir}/libgnutls{,xx}.la \
    %{buildroot}%{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.la


%files
%{gnuxc_datadir}/guile/site/gnutls
%{gnuxc_datadir}/guile/site/gnutls.scm
%{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.so.0
%{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.so.0.0.0
%{gnuxc_libdir}/libgnutls.so.30
%{gnuxc_libdir}/libgnutls.so.30.5.0
%{gnuxc_libdir}/libgnutlsxx.so.28
%{gnuxc_libdir}/libgnutlsxx.so.28.1.0
%doc AUTHORS ChangeLog NEWS README THANKS
%license COPYING COPYING.LESSER

%files devel
%{gnuxc_includedir}/gnutls
%{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.so
%{gnuxc_libdir}/libgnutls.so
%{gnuxc_libdir}/libgnutlsxx.so
%{gnuxc_libdir}/pkgconfig/gnutls.pc

%files static
%{gnuxc_libdir}/guile/2.0/guile-gnutls-v-2.a
%{gnuxc_libdir}/libgnutls.a
%{gnuxc_libdir}/libgnutlsxx.a


%changelog
