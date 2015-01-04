%?gnuxc_package_header

Name:           gnuxc-cloog
Version:        0.18.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2.1+
Group:          Development/Libraries
URL:            http://www.cloog.org/
Source0:        http://www.bastoul.net/cloog/pages/download/%{gnuxc_name}-%{version}.tar.gz

Patch101:       %{gnuxc_name}-%{version}-update-isl.patch

BuildRequires:  gnuxc-isl-devel
BuildRequires:  gnuxc-osl-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-isl-devel
Requires:       gnuxc-osl-devel

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
%patch101

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-portable-binary \
    --with-gcc-arch=%{gnuxc_arch} \
    --with-gmp=system \
    --with-isl=system \
    --with-osl=system
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/cloog

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libcloog-isl.la

# This functionality should be used from the system package.
rm -f %{buildroot}%{gnuxc_libdir}/{cloog-isl/cloog-isl,isl/isl}-config.cmake


%files
%{gnuxc_libdir}/libcloog-isl.so.4
%{gnuxc_libdir}/libcloog-isl.so.4.0.0
%doc doc/ROADMAP doc/TODO ChangeLog LICENSE README

%files devel
%{gnuxc_includedir}/cloog
%{gnuxc_libdir}/libcloog-isl.so
%{gnuxc_libdir}/pkgconfig/cloog-isl.pc

%files static
%{gnuxc_libdir}/libcloog-isl.a


%changelog
