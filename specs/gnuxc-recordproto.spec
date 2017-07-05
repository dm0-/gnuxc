%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-recordproto
Version:        1.14.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
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
    --disable-specs \
    \
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_includedir}/X11/extensions/recordconst.h
%{gnuxc_includedir}/X11/extensions/recordproto.h
%{gnuxc_includedir}/X11/extensions/recordstr.h
%{gnuxc_libdir}/pkgconfig/recordproto.pc
%doc ChangeLog README
%license COPYING
