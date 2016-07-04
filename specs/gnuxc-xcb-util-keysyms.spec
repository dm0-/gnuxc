%?gnuxc_package_header

Name:           gnuxc-xcb-util-keysyms
Version:        0.4.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://xcb.freedesktop.org/
Source0:        http://xcb.freedesktop.org/dist/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libxcb-devel
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
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-devel-docs \
    \
    --disable-silent-rules \
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libxcb-keysyms.la


%files
%{gnuxc_libdir}/libxcb-keysyms.so.1
%{gnuxc_libdir}/libxcb-keysyms.so.1.0.0
%doc ChangeLog NEWS README

%files devel
%{gnuxc_includedir}/xcb/xcb_keysyms.h
%{gnuxc_libdir}/libxcb-keysyms.so
%{gnuxc_libdir}/pkgconfig/xcb-keysyms.pc

%files static
%{gnuxc_libdir}/libxcb-keysyms.a
