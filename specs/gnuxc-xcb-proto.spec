%?gnuxc_package_header
%undefine debug_package

Name:           gnuxc-xcb-proto
Version:        1.8
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/Libraries
URL:            http://xcb.freedesktop.org/
Source0:        http://xcb.freedesktop.org/dist/%{gnuxc_name}-%{version}.tar.bz2

Requires:       gnuxc-filesystem

BuildArch:      noarch

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Force packages to use files from the sysroot.
sed -i \
    -e 's,@xcbincludedir@,%{gnuxc_datadir}/xcb,g' \
    -e 's,@pythondir@,%{gnuxc_libdir}/python2.7/site-packages,g' \
    xcb-proto.pc.in

%build
%gnuxc_configure
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_datadir}/xcb
%{gnuxc_libdir}/python2.7/site-packages/xcbgen
%{gnuxc_libdir}/pkgconfig/xcb-proto.pc
%doc COPYING NEWS README TODO


%changelog
