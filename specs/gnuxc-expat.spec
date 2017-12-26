%?gnuxc_package_header

Name:           gnuxc-expat
Version:        2.2.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.libexpat.org/
Source0:        http://prdownloads.sourceforge.net/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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
%gnuxc_configure
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/xmlwf

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libexpat.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libexpat.so.1
%{gnuxc_libdir}/libexpat.so.1.6.7
%doc AUTHORS Changes README.md
%license COPYING

%files devel
%{gnuxc_includedir}/expat.h
%{gnuxc_includedir}/expat_config.h
%{gnuxc_includedir}/expat_external.h
%{gnuxc_libdir}/libexpat.so
%{gnuxc_libdir}/pkgconfig/expat.pc

%files static
%{gnuxc_libdir}/libexpat.a
