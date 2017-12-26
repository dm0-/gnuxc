%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-shared-mime-info
Version:        1.9
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv2+
URL:            http://freedesktop.org/wiki/Software/shared-mime-info
Source0:        http://people.freedesktop.org/~hadess/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-libxml2-devel

BuildRequires:  intltool

Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-update-mimedb

%install
%gnuxc_make install-pkgconfigDATA DESTDIR=%{buildroot}


%files
%{gnuxc_datadir}/pkgconfig/shared-mime-info.pc
%doc ChangeLog HACKING NEWS README
%license COPYING
