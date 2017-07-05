%?gnuxc_package_header

Name:           gnuxc-gmp
Version:        6.1.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+
URL:            http://www.gnu.org/software/gmp/
Source0:        http://ftpmirror.gnu.org/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gcc-c++

BuildRequires:  m4

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
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --enable-assembly \
    --enable-assert \
    --enable-cxx \
    --enable-fft
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libgmp{,xx}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir}


%files
%{gnuxc_libdir}/libgmp.so.10
%{gnuxc_libdir}/libgmp.so.10.3.2
%{gnuxc_libdir}/libgmpxx.so.4
%{gnuxc_libdir}/libgmpxx.so.4.5.2
%doc AUTHORS ChangeLog NEWS README
%license COPYING COPYING.LESSERv3 COPYINGv2 COPYINGv3

%files devel
%{gnuxc_includedir}/gmp.h
%{gnuxc_includedir}/gmpxx.h
%{gnuxc_libdir}/libgmp.so
%{gnuxc_libdir}/libgmpxx.so

%files static
%{gnuxc_libdir}/libgmp.a
%{gnuxc_libdir}/libgmpxx.a
