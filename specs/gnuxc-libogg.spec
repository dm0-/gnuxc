%?gnuxc_package_header

Name:           gnuxc-libogg
Version:        1.3.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.xiph.org/ogg/
Source0:        http://downloads.xiph.org/releases/ogg/%{gnuxc_name}-%{version}.tar.xz

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

%build
%gnuxc_configure
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libogg.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}


%files
%{gnuxc_libdir}/libogg.so.0
%{gnuxc_libdir}/libogg.so.0.8.2
%doc AUTHORS CHANGES README
%license COPYING

%files devel
%{gnuxc_includedir}/ogg
%{gnuxc_libdir}/libogg.so
%{gnuxc_libdir}/pkgconfig/ogg.pc

%files static
%{gnuxc_libdir}/libogg.a
