%?gnuxc_package_header

Name:           gnuxc-mpfr
Version:        3.1.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+ and GPLv3+ and GFDL
URL:            http://www.gnu.org/software/mpfr/
Source0:        http://ftpmirror.gnu.org/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gmp-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gmp-devel

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
    --enable-assert \
    --enable-thread-safe \
    --enable-warnings
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libmpfr.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_infodir}


%files
%{gnuxc_libdir}/libmpfr.so.4
%{gnuxc_libdir}/libmpfr.so.4.1.5
%doc AUTHORS BUGS ChangeLog NEWS README TODO
%license COPYING COPYING.LESSER

%files devel
%{gnuxc_includedir}/mpf2mpfr.h
%{gnuxc_includedir}/mpfr.h
%{gnuxc_libdir}/libmpfr.so

%files static
%{gnuxc_libdir}/libmpfr.a
