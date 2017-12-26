%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-presentproto
Version:        1.1
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
%autosetup -n %{gnuxc_name}-%{version}

# Installed headers use types defined in xproto headers.
echo 'Requires: xproto' >> %{gnuxc_name}.pc.in

%build
%gnuxc_configure \
    --enable-strict-compilation
%gnuxc_make_build all

%install
%gnuxc_make_install

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}


%files
%{gnuxc_includedir}/X11/extensions/presentproto.h
%{gnuxc_includedir}/X11/extensions/presenttokens.h
%{gnuxc_libdir}/pkgconfig/presentproto.pc
%doc ChangeLog presentproto.txt
