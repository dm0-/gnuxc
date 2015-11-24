%?gnuxc_package_header

Name:           gnuxc-libatomic_ops
Version:        7.4.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD and MIT and GPLv2+
Group:          System Environment/Libraries
URL:            http://www.hboehm.info/gc/
Source0:        http://www.ivmaisoft.com/_bin/atomic_ops/%{gnuxc_name}-%{version}.tar.gz

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
    --enable-assertions \
    --enable-shared
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install
mv doc/LICENSING.txt .

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libatomic_ops{,_gpl}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/libatomic_ops


%files
%{gnuxc_libdir}/libatomic_ops.so.1
%{gnuxc_libdir}/libatomic_ops.so.1.0.3
%{gnuxc_libdir}/libatomic_ops_gpl.so.1
%{gnuxc_libdir}/libatomic_ops_gpl.so.1.0.3
%doc AUTHORS ChangeLog doc/*.txt README.md TODO
%license COPYING LICENSING.txt

%files devel
%{gnuxc_includedir}/atomic_ops
%{gnuxc_includedir}/atomic_ops.h
%{gnuxc_includedir}/atomic_ops_malloc.h
%{gnuxc_includedir}/atomic_ops_stack.h
%{gnuxc_libdir}/libatomic_ops.so
%{gnuxc_libdir}/libatomic_ops_gpl.so
%{gnuxc_libdir}/pkgconfig/atomic_ops.pc

%files static
%{gnuxc_libdir}/libatomic_ops.a
%{gnuxc_libdir}/libatomic_ops_gpl.a


%changelog
