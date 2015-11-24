%?gnuxc_package_header

Name:           gnuxc-bzip2
Version:        1.0.6
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
Group:          System Environment/Libraries
URL:            http://www.bzip.org/
Source0:        http://www.bzip.org/%{version}/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-glibc-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

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
%gnuxc_env
%gnuxc_make %{?_smp_mflags} libbz2.a \
    AR='%{gnuxc_ar}' CC='%{gnuxc_cc}' RANLIB='%{gnuxc_ranlib}' \
    CFLAGS='%{gnuxc_optflags}' LDFLAGS='%{gnuxc_ldflags}' \
    PREFIX='%{gnuxc_prefix}'
%gnuxc_make %{?_smp_mflags} -f Makefile-libbz2_so all \
    CC='%{gnuxc_cc}' \
    CFLAGS='%{gnuxc_optflags}'

%install
install -Dpm 644 bzlib.h %{buildroot}%{gnuxc_includedir}/bzlib.h
install -Dpm 644 libbz2.a %{buildroot}%{gnuxc_libdir}/libbz2.a
install -Dpm 755 -t %{buildroot}%{gnuxc_libdir} libbz2.so.%{version}
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


%changelog
