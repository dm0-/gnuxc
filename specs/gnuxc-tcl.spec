%?gnuxc_package_header

Name:           gnuxc-tcl
Version:        8.6.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        TCL
URL:            http://www.tcl.tk/
Source0:        http://prdownloads.sourceforge.net/%{gnuxc_name}/%{gnuxc_name}-core%{version}-src.tar.gz

BuildRequires:  gnuxc-zlib-devel

BuildRequires:  autoconf

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%setup -q -n %{gnuxc_name}%{version}

# Correct installed library permissions.
sed -i -e '/INSTALL_STUB_LIB=/s/LIBRARY/DATA/' unix/tcl.m4
sed -i -e '/chmod 555/d' unix/Makefile.in
autoreconf -fi unix

%build
%global _configure unix/configure
%gnuxc_configure \
    --disable-rpath \
    --enable-dll-unloading \
    --enable-langinfo \
    --enable-load \
    --enable-man-symlinks \
    --enable-shared \
    --enable-symbols \
    --enable-threads \
    --with-encoding=utf-8 \
    --without-tzdata \
    \
    --disable-64bit \
    --disable-64bit-vis
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install install-private-headers

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/tclsh8.6

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_libdir}/tcl{8,8.6}

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libtcl8.6.so
%doc ChangeLog* changes README
%license license.terms

%files devel
%{gnuxc_includedir}/tcl.h
%{gnuxc_includedir}/tclDecls.h
%{gnuxc_includedir}/tclInt.h
%{gnuxc_includedir}/tclIntDecls.h
%{gnuxc_includedir}/tclIntPlatDecls.h
%{gnuxc_includedir}/tclOO.h
%{gnuxc_includedir}/tclOODecls.h
%{gnuxc_includedir}/tclOOInt.h
%{gnuxc_includedir}/tclOOIntDecls.h
%{gnuxc_includedir}/tclPlatDecls.h
%{gnuxc_includedir}/tclPort.h
%{gnuxc_includedir}/tclTomMath.h
%{gnuxc_includedir}/tclTomMathDecls.h
%{gnuxc_includedir}/tclUnixPort.h
%{gnuxc_libdir}/libtclstub8.6.a
%{gnuxc_libdir}/pkgconfig/tcl.pc
%{gnuxc_libdir}/tclConfig.sh
%{gnuxc_libdir}/tclooConfig.sh
