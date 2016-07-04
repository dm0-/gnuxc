%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-xf86dgaproto
Version:        2.1
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
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_includedir}/X11/extensions/xf86dga.h
%{gnuxc_includedir}/X11/extensions/xf86dga1const.h
%{gnuxc_includedir}/X11/extensions/xf86dga1proto.h
%{gnuxc_includedir}/X11/extensions/xf86dga1str.h
%{gnuxc_includedir}/X11/extensions/xf86dgaconst.h
%{gnuxc_includedir}/X11/extensions/xf86dgaproto.h
%{gnuxc_includedir}/X11/extensions/xf86dgastr.h
%{gnuxc_libdir}/pkgconfig/xf86dgaproto.pc
%doc ChangeLog
%license COPYING
