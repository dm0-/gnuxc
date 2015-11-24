%?gnuxc_package_header

Name:           gnuxc-libffi
Version:        3.2.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
Group:          System Environment/Libraries
URL:            http://sourceware.org/libffi/
Source0:        ftp://sourceware.org/pub/libffi/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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

%build
%gnuxc_configure \
    --enable-debug
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libffi.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libffi.so.6
%{gnuxc_libdir}/libffi.so.6.0.4
%doc ChangeLog* README
%license LICENSE

%files devel
%{gnuxc_libdir}/%{gnuxc_name}-%{version}
%{gnuxc_libdir}/libffi.so
%{gnuxc_libdir}/pkgconfig/libffi.pc

%files static
%{gnuxc_libdir}/libffi.a


%changelog
