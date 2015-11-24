%?gnuxc_package_header

Name:           gnuxc-libepoxy
Version:        1.3.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://github.com/anholt/libepoxy
Source0:        http://github.com/anholt/%{gnuxc_name}/releases/download/v%{version}/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-mesa-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  python3

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-mesa-devel

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
    --disable-silent-rules \
    --enable-static \
    \
    --disable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libepoxy.la


%files
%{gnuxc_libdir}/libepoxy.so.0
%{gnuxc_libdir}/libepoxy.so.0.0.0
%doc README.md
%license COPYING

%files devel
%{gnuxc_includedir}/epoxy
%{gnuxc_libdir}/libepoxy.so
%{gnuxc_libdir}/pkgconfig/epoxy.pc

%files static
%{gnuxc_libdir}/libepoxy.a


%changelog
