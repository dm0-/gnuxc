%?gnuxc_package_header

Name:           gnuxc-harfbuzz
Version:        0.9.37
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://harfbuzz.org/
Source0:        http://www.freedesktop.org/software/%{gnuxc_name}/release/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-cairo-devel
BuildRequires:  gnuxc-freetype-devel
BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-icu4c-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-freetype-devel
Requires:       gnuxc-glib-devel
Requires:       gnuxc-icu4c-devel

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
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' configure

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-static \
    --with-cairo \
    --with-freetype \
    --with-glib \
    --with-gobject \
    --with-icu \
    \
    --without-coretext \
    --without-graphite2 \
    --without-uniscribe
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/hb-{ot-shape-closure,shape,view}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libharfbuzz{,-gobject,-icu}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc


%files
%{gnuxc_libdir}/libharfbuzz.so.0
%{gnuxc_libdir}/libharfbuzz.so.0.937.0
%{gnuxc_libdir}/libharfbuzz-gobject.so.0
%{gnuxc_libdir}/libharfbuzz-gobject.so.0.937.0
%{gnuxc_libdir}/libharfbuzz-icu.so.0
%{gnuxc_libdir}/libharfbuzz-icu.so.0.937.0
%doc AUTHORS ChangeLog COPYING NEWS README THANKS TODO

%files devel
%{gnuxc_includedir}/harfbuzz
%{gnuxc_libdir}/libharfbuzz.so
%{gnuxc_libdir}/libharfbuzz-gobject.so
%{gnuxc_libdir}/libharfbuzz-icu.so
%{gnuxc_libdir}/pkgconfig/harfbuzz.pc
%{gnuxc_libdir}/pkgconfig/harfbuzz-gobject.pc
%{gnuxc_libdir}/pkgconfig/harfbuzz-icu.pc

%files static
%{gnuxc_libdir}/libharfbuzz.a
%{gnuxc_libdir}/libharfbuzz-gobject.a
%{gnuxc_libdir}/libharfbuzz-icu.a


%changelog
