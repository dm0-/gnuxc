%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-glproto
Version:        1.4.17
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/System
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/proto/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-filesystem

Requires:       gnuxc-xproto
Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_includedir}/GL/glxint.h
%{gnuxc_includedir}/GL/glxmd.h
%{gnuxc_includedir}/GL/glxproto.h
%{gnuxc_includedir}/GL/glxtokens.h
%{gnuxc_includedir}/GL/internal
%{gnuxc_libdir}/pkgconfig/glproto.pc
%doc ChangeLog README
%license COPYING


%changelog
