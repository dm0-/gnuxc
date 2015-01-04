%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-spice-protocol
Version:        0.12.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD and LGPLv2+
Group:          Development/System
URL:            http://www.spice-space.org/
Source0:        http://www.spice-space.org/download/releases/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-filesystem

Requires:       gnuxc-filesystem
Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_datadir}/pkgconfig/spice-protocol.pc
%{gnuxc_includedir}/spice-1
%doc AUTHORS ChangeLog COPYING NEWS README


%changelog
