%?gnuxc_package_header

Name:           gnuxc-libxkbfile
Version:        1.0.9
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libX11-devel
BuildRequires:  gnuxc-pkg-config

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
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libxkbfile.la


%files
%{gnuxc_libdir}/libxkbfile.so.1
%{gnuxc_libdir}/libxkbfile.so.1.0.2
%doc ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/extensions/XKBbells.h
%{gnuxc_includedir}/X11/extensions/XKBconfig.h
%{gnuxc_includedir}/X11/extensions/XKBfile.h
%{gnuxc_includedir}/X11/extensions/XKBrules.h
%{gnuxc_includedir}/X11/extensions/XKM.h
%{gnuxc_includedir}/X11/extensions/XKMformat.h
%{gnuxc_libdir}/libxkbfile.so
%{gnuxc_libdir}/pkgconfig/xkbfile.pc

%files static
%{gnuxc_libdir}/libxkbfile.a
