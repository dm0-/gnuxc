%?gnuxc_package_header

Name:           gnuxc-tk
Version:        8.6.4
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        TCL
Group:          Development/Languages
URL:            http://www.tcl.tk/
Source0:        http://prdownloads.sourceforge.net/tcl/%{gnuxc_name}%{version}-src.tar.gz

BuildRequires:  gnuxc-libXft-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-tcl-devel

BuildRequires:  autoconf

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-tcl-devel

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%setup -q -n %{gnuxc_name}%{version}

# Use an appropriate pkg-config.
sed -i -e '/_\(CFLAG\|LIB\)S=/s/pkg-config/%{gnuxc_pkgconfig}/' unix/configure.in

# Correct installed library permissions.
sed -i -e '/INSTALL_STUB_LIB=/s/LIBRARY/DATA/' unix/tcl.m4
sed -i -e '/chmod 555/d' unix/Makefile.in
autoreconf -fi unix

%build
%global _configure unix/configure
%gnuxc_configure \
    --disable-rpath \
    --enable-load \
    --enable-man-symlinks \
    --enable-shared \
    --enable-symbols \
    --enable-threads \
    --enable-xft \
    --with-tcl=%{gnuxc_libdir} \
    --with-x \
    \
    --disable-64bit \
    --disable-64bit-vis \
    --disable-xss
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/wish8.6

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_libdir}/tk8.6

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libtk8.6.so
%doc ChangeLog* changes README
%license license.terms

%files devel
%{gnuxc_includedir}/tk.h
%{gnuxc_includedir}/tkDecls.h
%{gnuxc_includedir}/tkPlatDecls.h
%{gnuxc_libdir}/libtkstub8.6.a
%{gnuxc_libdir}/pkgconfig/tk.pc
%{gnuxc_libdir}/tkConfig.sh


%changelog
