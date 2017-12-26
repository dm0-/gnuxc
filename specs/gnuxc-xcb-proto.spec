%?gnuxc_package_header
%global debug_package %{nil}
%undefine __python_requires

Name:           gnuxc-xcb-proto
Version:        1.12
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://xcb.freedesktop.org/
Source0:        http://xcb.freedesktop.org/dist/%{gnuxc_name}-%{version}.tar.bz2

Patch001:       http://cgit.freedesktop.org/xcb/proto/patch/?id=ea7a3ac6c658164690e0febb55f4467cb9e0bcac#/%{gnuxc_name}-%{version}-fix-tabs.patch
Patch002:       http://cgit.freedesktop.org/xcb/proto/patch/?id=bea5e1c85bdc0950913790364e18228f20395a3d#/%{gnuxc_name}-%{version}-fix-print.patch

Requires:       gnuxc-python
Provides:       %{name}-devel = %{version}-%{release}

BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-python-devel

BuildRequires:  python3-devel

%description
%{summary}.


%prep
%autosetup -n %{gnuxc_name}-%{version} -p1

# Force the cross-libxcb configuration to use files from the sysroot.
pyver=$(env -i %{gnuxc_pkgconfig} --modversion python3)
sed -i xcb-proto.pc.in \
    -e 's,@xcbincludedir@,%{gnuxc_datadir}/xcb,g' \
    -e "s,@pythondir@,%{gnuxc_libdir}/python$pyver/site-packages,g"

%build
%gnuxc_configure
%gnuxc_make_build all

%install
%gnuxc_make_install

%files
%{gnuxc_datadir}/xcb
%{gnuxc_libdir}/pkgconfig/xcb-proto.pc
%{gnuxc_libdir}/python*.*/site-packages/xcbgen
%doc NEWS README TODO
%license COPYING
