%?gnuxc_package_header

Name:           gnuxc-nettle
Version:        2.7.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
Group:          Development/Libraries
URL:            http://www.gnu.org/software/nettle/
Source0:        http://ftpmirror.gnu.org/nettle/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-gmp-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gmp-devel

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
%gnuxc_configure \
    --disable-documentation \
    \
    --disable-openssl
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{nettle-{hash,lfib-stream},{pkcs1,sexp}-conv}

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 755 %{buildroot}%{gnuxc_libdir}/lib{hogweed,nettle}.so.*.*


%files
%{gnuxc_libdir}/libhogweed.so.2
%{gnuxc_libdir}/libhogweed.so.2.5
%{gnuxc_libdir}/libnettle.so.4
%{gnuxc_libdir}/libnettle.so.4.7
%doc AUTHORS ChangeLog COPYING.LIB descore.README NEWS README TODO

%files devel
%{gnuxc_includedir}/nettle
%{gnuxc_libdir}/libhogweed.so
%{gnuxc_libdir}/libnettle.so
%{gnuxc_libdir}/pkgconfig/hogweed.pc
%{gnuxc_libdir}/pkgconfig/nettle.pc

%files static
%{gnuxc_libdir}/libhogweed.a
%{gnuxc_libdir}/libnettle.a


%changelog
