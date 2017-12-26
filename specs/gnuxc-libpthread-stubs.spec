%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-libpthread-stubs
Version:        0.4
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://xcb.freedesktop.org/
Source0:        http://xcb.freedesktop.org/dist/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel

Requires:       gnuxc-glibc-devel
Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure
%gnuxc_make_build all

%install
%gnuxc_make_install


%files
%{gnuxc_libdir}/pkgconfig/pthread-stubs.pc
%doc README
%license COPYING
