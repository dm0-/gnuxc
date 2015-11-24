%?gnuxc_package_header
%global debug_package %{nil}
%undefine __python_requires

Name:           gnuxc-xcb-proto
Version:        1.11
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/Libraries
URL:            http://xcb.freedesktop.org/
Source0:        http://xcb.freedesktop.org/dist/%{gnuxc_name}-%{version}.tar.bz2

Requires:       gnuxc-python
Provides:       %{name}-devel = %{version}-%{release}

BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-python-devel

BuildRequires:  python3-devel

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Force the cross-libxcb configuration to use files from the sysroot.
pyver=$(env -i %{gnuxc_pkgconfig} --modversion python3)
sed -i xcb-proto.pc.in \
    -e 's,@xcbincludedir@,%{gnuxc_datadir}/xcb,g' \
    -e "s,@pythondir@,%{gnuxc_libdir}/python$pyver/site-packages,g"

%build
%gnuxc_configure
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

%files
%{gnuxc_datadir}/xcb
%{gnuxc_libdir}/pkgconfig/xcb-proto.pc
%{gnuxc_libdir}/python*.*/site-packages/xcbgen
%doc NEWS README TODO
%license COPYING


%changelog
