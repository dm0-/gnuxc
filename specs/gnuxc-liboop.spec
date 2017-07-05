%?gnuxc_package_header

Name:           gnuxc-liboop
Version:        1.0.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://www.lysator.liu.se/liboop/
Source0:        http://ftp.lysator.liu.se/pub/liboop/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-readline-devel
BuildRequires:  gnuxc-tcl-devel

BuildRequires:  libtool

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

# Rewrite the old configure script to support a newer TCL version.
sed -i -e '/for version in /s/ 8.4 / 8.6&/' configure.ac
autoreconf -fi

%build
%gnuxc_configure \
    --with-glib \
    --with-readline \
    --with-tcl \
    --without-adns \
    --without-libwww
%gnuxc_make -j1 all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/liboop{,-glib2,-rl,-tcl}.la


%files
%{gnuxc_libdir}/liboop.so.4
%{gnuxc_libdir}/liboop.so.4.1.0
%{gnuxc_libdir}/liboop-glib2.so.0
%{gnuxc_libdir}/liboop-glib2.so.0.0.0
%{gnuxc_libdir}/liboop-rl.so.0
%{gnuxc_libdir}/liboop-rl.so.0.0.0
%{gnuxc_libdir}/liboop-tcl.so.0
%{gnuxc_libdir}/liboop-tcl.so.0.0.0
%license COPYING

%files devel
%{gnuxc_includedir}/oop.h
%{gnuxc_includedir}/oop-adns.h
%{gnuxc_includedir}/oop-glib.h
%{gnuxc_includedir}/oop-read.h
%{gnuxc_includedir}/oop-rl.h
%{gnuxc_includedir}/oop-tcl.h
%{gnuxc_includedir}/oop-www.h
%{gnuxc_libdir}/liboop.so
%{gnuxc_libdir}/liboop-glib2.so
%{gnuxc_libdir}/liboop-rl.so
%{gnuxc_libdir}/liboop-tcl.so
%{gnuxc_libdir}/pkgconfig/liboop.pc
%{gnuxc_libdir}/pkgconfig/liboop-glib2.pc

%files static
%{gnuxc_libdir}/liboop.a
%{gnuxc_libdir}/liboop-glib2.a
%{gnuxc_libdir}/liboop-rl.a
%{gnuxc_libdir}/liboop-tcl.a
