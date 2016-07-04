%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-bigreqsproto
Version:        1.1.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/proto/%{gnuxc_name}-%{version}.tar.bz2

# This is not actually used; it's just for automatic pkg-config dependencies.
BuildRequires:  gnuxc-xproto

Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Installed headers use types defined in xproto headers.
echo 'Requires: xproto' >> %{gnuxc_name}.pc.in

%build
%gnuxc_configure \
    --disable-specs \
    \
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_includedir}/X11/extensions/bigreqsproto.h
%{gnuxc_includedir}/X11/extensions/bigreqstr.h
%{gnuxc_libdir}/pkgconfig/bigreqsproto.pc
%doc ChangeLog README
%license COPYING
