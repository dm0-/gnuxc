%?gnuxc_package_header

Name:           gnuxc-icu4c
Version:        60.2
%global majorv  %(v=%{version} ; echo -n ${v%%.*})
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT and UCD and Public Domain
URL:            http://www.icu-project.org/
Source0:        http://download.icu-project.org/files/icu4c/%{version}/%{gnuxc_name}-%{majorv}_2-src.tgz

BuildRequires:  gnuxc-gcc-c++

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gcc-c++

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
%autosetup -n icu

%build
%global _configure ../source/configure
mkdir native && (pushd native
%configure
popd)

%make_build -C native all VERBOSE=1

%global _configure ./configure
(pushd source
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    --with-cross-build="${PWD%/*}/native" \
    \
    --disable-rpath \
    --enable-debug \
    --enable-dyload \
    --enable-extras \
    --enable-icuio \
    --enable-plugins \
    --enable-static \
    --enable-strict \
    --enable-tracing \
    --with-data-packaging=library
popd)

%gnuxc_make_build -C source all VERBOSE=1

%install
%gnuxc_make_install -C source VERBOSE=1

# Provide a cross-tools version of the config script.
install -dm 0755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/icu-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-icu-config

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_sbindir}/gen{ccode,cmn,norm2,sprep} \
    %{buildroot}%{gnuxc_sbindir}/{escapesrc,icupkg} \
    %{buildroot}%{gnuxc_root}/bin/{derb,icuinfo,{make,u}conv,pkgdata} \
    %{buildroot}%{gnuxc_root}/bin/gen{brk,cfu,cnval,dict,rb}

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/icu

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libicudata.so.%{majorv}
%{gnuxc_libdir}/libicudata.so.%{version}
%{gnuxc_libdir}/libicui18n.so.%{majorv}
%{gnuxc_libdir}/libicui18n.so.%{version}
%{gnuxc_libdir}/libicuio.so.%{majorv}
%{gnuxc_libdir}/libicuio.so.%{version}
%{gnuxc_libdir}/libicutest.so.%{majorv}
%{gnuxc_libdir}/libicutest.so.%{version}
%{gnuxc_libdir}/libicutu.so.%{majorv}
%{gnuxc_libdir}/libicutu.so.%{version}
%{gnuxc_libdir}/libicuuc.so.%{majorv}
%{gnuxc_libdir}/libicuuc.so.%{version}
%doc APIChangeReport.html icu4c.css readme.html
%license icu4c.css license.html

%files devel
%{_bindir}/%{gnuxc_target}-icu-config
%{gnuxc_root}/bin/icu-config
%{gnuxc_includedir}/unicode
%{gnuxc_libdir}/icu
%{gnuxc_libdir}/libicudata.so
%{gnuxc_libdir}/libicui18n.so
%{gnuxc_libdir}/libicuio.so
%{gnuxc_libdir}/libicutest.so
%{gnuxc_libdir}/libicutu.so
%{gnuxc_libdir}/libicuuc.so
%{gnuxc_libdir}/pkgconfig/icu-i18n.pc
%{gnuxc_libdir}/pkgconfig/icu-io.pc
%{gnuxc_libdir}/pkgconfig/icu-uc.pc

%files static
%{gnuxc_libdir}/libicudata.a
%{gnuxc_libdir}/libicui18n.a
%{gnuxc_libdir}/libicuio.a
%{gnuxc_libdir}/libicutest.a
%{gnuxc_libdir}/libicutu.a
%{gnuxc_libdir}/libicuuc.a
