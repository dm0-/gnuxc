%?gnuxc_package_header

Name:           gnuxc-isl
Version:        0.14
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/Libraries
URL:            http://isl.gforge.inria.fr/
Source0:        http://isl.gforge.inria.fr/%{gnuxc_name}-%{version}.tar.xz

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
    --disable-silent-rules \
    --enable-portable-binary \
    --with-gcc-arch=%{gnuxc_arch} \
    --with-gmp=system \
    --with-int=gmp
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libisl.la


%files
%{gnuxc_libdir}/libisl.so.13
%{gnuxc_libdir}/libisl.so.13.1.0
%doc doc/manual.pdf AUTHORS ChangeLog LICENSE README

%files devel
%{gnuxc_includedir}/isl
%{gnuxc_libdir}/libisl.so
%{gnuxc_libdir}/libisl.so.13.1.0-gdb.py
%{gnuxc_libdir}/libisl.so.13.1.0-gdb.pyc
%{gnuxc_libdir}/libisl.so.13.1.0-gdb.pyo
%{gnuxc_libdir}/pkgconfig/isl.pc

%files static
%{gnuxc_libdir}/libisl.a


%changelog
