%bcond_with bootstrap

%?gnuxc_package_header

Name:           gnuxc-gc
Version:        7.6.2
Release:        1.%{without bootstrap}%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.hboehm.info/gc/
Source0:        http://github.com/ivmai/bdwgc/releases/download/v%{version}/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-libatomic_ops-devel
BuildRequires:  gnuxc-pkg-config
%if %{with bootstrap}
BuildRequires:  gnuxc-gcc
%else
BuildRequires:  gnuxc-gcc-c++
%endif

%if %{with bootstrap}
Provides:       gnuxc-bootstrap(%{gnuxc_name}) = %{version}-%{release}
%else
Obsoletes:      gnuxc-bootstrap(%{gnuxc_name}) <= %{version}-%{release}
%endif

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libatomic_ops-devel

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

%if %{without bootstrap}
%package c++
Summary:        Cross-compiled version of %{gnuxc_name}-c++ for the GNU system
Requires:       %{name} = %{version}-%{release}

%description c++
%{summary}.

%package c++-devel
Summary:        Development files for %{name}-c++
Requires:       %{name}-devel = %{version}-%{release}
Requires:       gnuxc-gcc-c++

%description c++-devel
The %{name}-c++-devel package contains libraries and header files for
developing applications that use %{gnuxc_name}-c++ on GNU systems.

%package c++-static
Summary:        Static libraries of %{name}-c++
Requires:       %{name}-c++-devel = %{version}-%{release}
Requires:       %{name}-static = %{version}-%{release}

%description c++-static
The %{name}-c++-static package contains the %{gnuxc_name}-c++ static libraries
for -static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.
%endif


%prep
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-docs \
    \
    --enable-cplusplus \
    --enable-large-config \
    --enable-parallel-mark \
    --enable-threads=posix \
    --with-libatomic_ops \
    \
    --enable-gc-assertions \
    --enable-gc-debug \
    \
%if %{with bootstrap}
    --disable-cplusplus \
%endif
    --disable-gcj-support \
    --disable-handle-fork \
    --disable-sigrt-signals
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/lib{cord,gc,gccpp}.la


%files
%{gnuxc_libdir}/libcord.so.1
%{gnuxc_libdir}/libcord.so.1.3.0
%{gnuxc_libdir}/libgc.so.2
%{gnuxc_libdir}/libgc.so.2.2.1
%doc AUTHORS ChangeLog doc README*

%files devel
%{gnuxc_includedir}/gc
%{gnuxc_includedir}/gc.h
%{gnuxc_libdir}/libcord.so
%{gnuxc_libdir}/libgc.so
%{gnuxc_libdir}/pkgconfig/bdw-gc.pc

%files static
%{gnuxc_libdir}/libcord.a
%{gnuxc_libdir}/libgc.a

%if %{without bootstrap}
%files c++
%{gnuxc_libdir}/libgccpp.so.1
%{gnuxc_libdir}/libgccpp.so.1.3.0

%files c++-devel
%{gnuxc_includedir}/gc_cpp.h
%{gnuxc_libdir}/libgccpp.so

%files c++-static
%{gnuxc_libdir}/libgccpp.a
%endif
