%?gnuxc_package_header

Name:           gnuxc-libXdmcp
Version:        1.1.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xproto

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-xproto

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.

%package static
Summary:        Static libraries of %{name}
Group:          Development/Libraries
Requires:       %{name}-devel = %{version}-%{release}

%description static
The %{name}-static package contains the %{gnuxc_name} static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-docs \
    \
    --disable-silent-rules \
    --enable-strict-compilation
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXdmcp.la


%files
%{gnuxc_libdir}/libXdmcp.so.6
%{gnuxc_libdir}/libXdmcp.so.6.0.0
%doc AUTHORS ChangeLog README Wraphelp.README.crypto
%license COPYING

%files devel
%{gnuxc_includedir}/X11/Xdmcp.h
%{gnuxc_libdir}/libXdmcp.so
%{gnuxc_libdir}/pkgconfig/xdmcp.pc

%files static
%{gnuxc_libdir}/libXdmcp.a


%changelog
