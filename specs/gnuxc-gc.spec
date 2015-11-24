%?gnuxc_package_header

Name:           gnuxc-gc
Version:        7.4.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
Group:          System Environment/Libraries
URL:            http://www.hboehm.info/gc/
Source0:        http://www.hboehm.info/gc/gc_source/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-libatomic_ops-devel
BuildRequires:  gnuxc-pkg-config

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gcc-c++
Requires:       gnuxc-libatomic_ops-devel

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

# Seriously disable rpaths.
sed -i -e 's/\(need_relink\)=yes/\1=no/' ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__BAD_LIBTOOL__/' configure

%build
%gnuxc_configure \
    --enable-cplusplus \
    --enable-large-config \
    --enable-parallel-mark \
    --enable-threads=posix \
    --with-libatomic_ops \
    \
    --enable-gc-assertions \
    --enable-gc-debug \
    \
    --disable-gcj-support \
    --disable-handle-fork \
    --disable-sigrt-signals
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/lib{cord,gc,gccpp}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gc


%files
%{gnuxc_libdir}/libcord.so.1
%{gnuxc_libdir}/libcord.so.1.0.3
%{gnuxc_libdir}/libgc.so.1
%{gnuxc_libdir}/libgc.so.1.0.3
%{gnuxc_libdir}/libgccpp.so.1
%{gnuxc_libdir}/libgccpp.so.1.0.3
%doc AUTHORS ChangeLog doc README* TODO

%files devel
%{gnuxc_includedir}/gc
%{gnuxc_includedir}/gc.h
%{gnuxc_includedir}/gc_cpp.h
%{gnuxc_libdir}/libcord.so
%{gnuxc_libdir}/libgc.so
%{gnuxc_libdir}/libgccpp.so
%{gnuxc_libdir}/pkgconfig/bdw-gc.pc

%files static
%{gnuxc_libdir}/libcord.a
%{gnuxc_libdir}/libgc.a
%{gnuxc_libdir}/libgccpp.a


%changelog
