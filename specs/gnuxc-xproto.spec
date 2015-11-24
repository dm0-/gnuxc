%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-xproto
Version:        7.0.28
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/System
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/proto/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-filesystem

Requires:       gnuxc-filesystem
Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-specs \
    \
    --enable-const-prototypes \
    --enable-function-prototypes \
    --enable-nested-prototypes \
    --enable-strict-compilation \
    --enable-varargs-prototypes \
    --enable-wide-prototypes
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide this parent directory for GLX headers.
install -dm 755 %{buildroot}%{gnuxc_includedir}/GL


%files
%{gnuxc_includedir}/GL
%{gnuxc_includedir}/X11
%{gnuxc_libdir}/pkgconfig/xproto.pc
%doc AUTHORS ChangeLog README
%license COPYING


%changelog
