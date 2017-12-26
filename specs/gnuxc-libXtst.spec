%?gnuxc_package_header

Name:           gnuxc-libXtst
Version:        1.2.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libXi-devel
BuildRequires:  gnuxc-recordproto

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

%build
%gnuxc_configure \
    --disable-specs \
    \
    --enable-strict-compilation
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXtst.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXtst.so.6
%{gnuxc_libdir}/libXtst.so.6.1.0
%doc ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/extensions/record.h
%{gnuxc_includedir}/X11/extensions/XTest.h
%{gnuxc_libdir}/libXtst.so
%{gnuxc_libdir}/pkgconfig/xtst.pc

%files static
%{gnuxc_libdir}/libXtst.a
