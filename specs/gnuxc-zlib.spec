%?gnuxc_package_header

Name:           gnuxc-zlib
Version:        1.2.11
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        zlib and Boost
URL:            http://zlib.net/
Source0:        http://zlib.net/%{gnuxc_name}-%{version}.tar.gz

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
%setup -q -n %{gnuxc_name}-%{version}

# This variable is redundant and problematic in the sysroot.
sed -i -e 's/ -L.{sharedlibdir}//g' zlib.pc.in

%build
%gnuxc_env
CHOST=%{gnuxc_host} %_configure \
    --prefix=%{gnuxc_prefix} \
    --eprefix=%{gnuxc_exec_prefix} \
    --includedir=%{gnuxc_includedir} \
    --libdir=%{gnuxc_libdir} \
    --sharedlibdir=%{gnuxc_libdir} \
    --uname=GNU
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libz.so.1
%{gnuxc_libdir}/libz.so.%{version}
%doc ChangeLog doc FAQ README

%files devel
%{gnuxc_includedir}/zlib.h
%{gnuxc_includedir}/zconf.h
%{gnuxc_libdir}/libz.so
%{gnuxc_libdir}/pkgconfig/zlib.pc

%files static
%{gnuxc_libdir}/libz.a
