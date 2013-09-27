%?gnuxc_package_header

Name:           gnuxc-piplib
Version:        1.4.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2.1+
Group:          Development/Libraries
URL:            http://www.piplib.org/
Source0:        http://www.bastoul.net/cloog/pages/download/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-gmp-devel

BuildArch:      noarch

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
touch NEWS AUTHORS ChangeLog && autoreconf -f -i

%build
%global _configure ../configure
%global piplib_configuration \\\
    --enable-portable-binary \\\
    --with-gcc-arch=%{gnuxc_arch}
mkdir -p int && pushd int
%gnuxc_configure %{piplib_configuration} \
    --enable-int-version
popd
mkdir -p llint && pushd llint
%gnuxc_configure %{piplib_configuration} \
    --enable-llint-version
popd
mkdir -p mp && pushd mp
%gnuxc_configure %{piplib_configuration} \
    --enable-mp-version
popd
%gnuxc_make -C int   %{?_smp_mflags} all
%gnuxc_make -C llint %{?_smp_mflags} all
%gnuxc_make -C mp    %{?_smp_mflags} all

%install
%gnuxc_make_install -C int
%gnuxc_make_install -C llint
%gnuxc_make_install -C mp

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/pip{32,64,MP}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpiplib{32,64,MP}.la


%files
%{gnuxc_libdir}/libpiplib32.so.2
%{gnuxc_libdir}/libpiplib32.so.2.1.0
%{gnuxc_libdir}/libpiplib64.so.2
%{gnuxc_libdir}/libpiplib64.so.2.1.0
%{gnuxc_libdir}/libpiplibMP.so.2
%{gnuxc_libdir}/libpiplibMP.so.2.1.0
%doc doc/piplib.pdf README

%files devel
%{gnuxc_includedir}/piplib
%{gnuxc_libdir}/libpiplib32.so
%{gnuxc_libdir}/libpiplib64.so
%{gnuxc_libdir}/libpiplibMP.so

%files static
%{gnuxc_libdir}/libpiplib32.a
%{gnuxc_libdir}/libpiplib64.a
%{gnuxc_libdir}/libpiplibMP.a


%changelog
