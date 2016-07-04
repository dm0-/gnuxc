%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-xtrans
Version:        1.3.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

# This is not actually used; it's just for automatic pkg-config dependencies.
BuildRequires:  gnuxc-xproto

Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Installed headers include xproto headers.
echo 'Requires: xproto' >> %{gnuxc_name}.pc.in

%build
%gnuxc_configure \
    --disable-docs \
    \
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal


%files
%{gnuxc_datadir}/pkgconfig/xtrans.pc
%{gnuxc_includedir}/X11/Xtrans
%doc AUTHORS ChangeLog README
%license COPYING
