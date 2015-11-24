%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-kbproto
Version:        1.0.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/System
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/proto/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-filesystem

Requires:       gnuxc-xextproto
Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-specs \
    \
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_includedir}/X11/extensions/XKB.h
%{gnuxc_includedir}/X11/extensions/XKBgeom.h
%{gnuxc_includedir}/X11/extensions/XKBproto.h
%{gnuxc_includedir}/X11/extensions/XKBstr.h
%{gnuxc_includedir}/X11/extensions/XKBsrv.h
%{gnuxc_libdir}/pkgconfig/kbproto.pc
%doc ChangeLog README
%license COPYING


%changelog
