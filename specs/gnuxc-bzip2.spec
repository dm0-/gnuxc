%?gnuxc_package_header

Name:           gnuxc-bzip2
Version:        1.0.6
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.bzip.org/
Source0:        http://www.bzip.org/%{version}/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-glibc-devel

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
%gnuxc_env
%gnuxc_make_build libbz2.a \
    AR="$AR" CC="$CC" RANLIB="$RANLIB" \
    CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" \
    PREFIX='%{gnuxc_prefix}'
%gnuxc_make_build -f Makefile-libbz2_so all \
    CC="$CC" \
    CFLAGS="$CFLAGS"

%install
install -Dpm 0644 bzlib.h %{buildroot}%{gnuxc_includedir}/bzlib.h
install -Dpm 0644 libbz2.a %{buildroot}%{gnuxc_libdir}/libbz2.a
install -Dpm 0755 -t %{buildroot}%{gnuxc_libdir} libbz2.so.%{version}
ln -fs libbz2.so.%{version} %{buildroot}%{gnuxc_libdir}/libbz2.so.1.0
ln -fs libbz2.so.1.0 %{buildroot}%{gnuxc_libdir}/libbz2.so


%files
%{gnuxc_libdir}/libbz2.so.1.0
%{gnuxc_libdir}/libbz2.so.%{version}
%doc CHANGES README*
%license LICENSE

%files devel
%{gnuxc_includedir}/bzlib.h
%{gnuxc_libdir}/libbz2.so

%files static
%{gnuxc_libdir}/libbz2.a
