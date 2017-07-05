%?gnuxc_package_header

Name:           gnuxc-json-c
Version:        0.12.1
%global snap    20160607
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://github.com/json-c/json-c
Source0:        http://github.com/json-c/json-c/archive/%{gnuxc_name}-%{version}-%{snap}.tar.gz

BuildRequires:  gnuxc-glibc-devel

BuildRequires:  libtool

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
%setup -q -n %{gnuxc_name}-%{gnuxc_name}-%{version}-%{snap}

# Remove bad hard-coded settings.
sed -i -e 's/ -Werror / /g' Makefile.am.inc

autoreconf -fi

%build
%gnuxc_configure \
    --enable-rdrand
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libjson-c.la


%files
%{gnuxc_libdir}/libjson-c.so.2
%{gnuxc_libdir}/libjson-c.so.2.0.2
%doc AUTHORS ChangeLog NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/json-c
%{gnuxc_libdir}/libjson-c.so
%{gnuxc_libdir}/pkgconfig/json-c.pc

%files static
%{gnuxc_libdir}/libjson-c.a
