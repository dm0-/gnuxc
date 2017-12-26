%?gnuxc_package_header

Name:           gnuxc-libtasn1
Version:        4.12
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+ and LGPLv2+
URL:            http://www.gnu.org/software/libtasn1
Source0:        http://ftpmirror.gnu.org/libtasn1/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

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
    --enable-gcc-warnings
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/asn1{Coding,Decoding,Parser}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libtasn1.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libtasn1.so.6
%{gnuxc_libdir}/libtasn1.so.6.5.4
%doc AUTHORS ChangeLog NEWS README THANKS doc/TODO
%license COPYING COPYING.LIB

%files devel
%{gnuxc_includedir}/libtasn1.h
%{gnuxc_libdir}/libtasn1.so
%{gnuxc_libdir}/pkgconfig/libtasn1.pc

%files static
%{gnuxc_libdir}/libtasn1.a
