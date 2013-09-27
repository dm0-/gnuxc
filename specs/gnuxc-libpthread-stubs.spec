%?gnuxc_package_header
%undefine debug_package

Name:           gnuxc-libpthread-stubs
Version:        0.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/Libraries
URL:            http://xcb.freedesktop.org/
Source0:        http://xcb.freedesktop.org/dist/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libpthread-devel

Requires:       gnuxc-libpthread-devel

BuildArch:      noarch

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    LIBS=-lpthread
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install


%files
%{gnuxc_libdir}/pkgconfig/pthread-stubs.pc
%doc COPYING README


%changelog
