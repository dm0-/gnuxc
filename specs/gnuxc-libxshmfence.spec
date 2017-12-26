%?gnuxc_package_header

Name:           gnuxc-libxshmfence
Version:        1.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-xproto

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.

%package static
Summary:        Static libraries of %{name}
Requires:       %{name}-devel = %{version}-%{release}

%description static
The %{name}-static package contains the %{gnuxc_name} static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.


%prep
%autosetup -n %{gnuxc_name}-%{version}

# Installed headers include xproto headers.
echo 'Requires: xproto' >> xshmfence.pc.in

%build
%gnuxc_configure \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libxshmfence.la


%files
%{gnuxc_libdir}/libxshmfence.so.1
%{gnuxc_libdir}/libxshmfence.so.1.0.0
%doc ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/xshmfence.h
%{gnuxc_libdir}/libxshmfence.so
%{gnuxc_libdir}/pkgconfig/xshmfence.pc

%files static
%{gnuxc_libdir}/libxshmfence.a
