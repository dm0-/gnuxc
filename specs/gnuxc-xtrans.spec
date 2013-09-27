%?gnuxc_package_header
%undefine debug_package

Name:           gnuxc-xtrans
Version:        1.2.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

Requires:       gnuxc-xproto

BuildArch:      noarch

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

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
%doc AUTHORS ChangeLog COPYING README


%changelog
