%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/pango/
%global __requires_exclude_from ^%{gnuxc_libdir}/pango/

Name:           gnuxc-pango
Version:        1.36.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
Group:          System Environment/Libraries
URL:            http://developer.gnome.org/pango/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/1.36/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-cairo-devel
BuildRequires:  gnuxc-harfbuzz-devel
BuildRequires:  gnuxc-libXft-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-cairo-devel
Requires:       gnuxc-harfbuzz-devel
Requires:       gnuxc-libXft-devel

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
    --enable-debug \
    --enable-explicit-deps \
    --enable-static \
    --with-cairo \
    --with-xft \
    \
    --disable-introspection
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/pango-{querymodules,view}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpango{,cairo,ft2,xft}-1.0.la \
    %{buildroot}%{gnuxc_libdir}/pango/1.8.0/modules/pango-basic-fc.la \
   %{buildroot}%{gnuxc_libdir}/pango/1.8.0/modules/pango-{arabic,indic}-lang.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpango-1.0.so.0
%{gnuxc_libdir}/libpango-1.0.so.0.3600.3
%{gnuxc_libdir}/libpangocairo-1.0.so.0
%{gnuxc_libdir}/libpangocairo-1.0.so.0.3600.3
%{gnuxc_libdir}/libpangoft2-1.0.so.0
%{gnuxc_libdir}/libpangoft2-1.0.so.0.3600.3
%{gnuxc_libdir}/libpangoxft-1.0.so.0
%{gnuxc_libdir}/libpangoxft-1.0.so.0.3600.3
%dir %{gnuxc_libdir}/pango
%dir %{gnuxc_libdir}/pango/1.8.0
%dir %{gnuxc_libdir}/pango/1.8.0/modules
%{gnuxc_libdir}/pango/1.8.0/modules/pango-arabic-lang.so
%{gnuxc_libdir}/pango/1.8.0/modules/pango-basic-fc.so
%{gnuxc_libdir}/pango/1.8.0/modules/pango-indic-lang.so
%doc AUTHORS ChangeLog* COPYING HACKING MAINTAINERS NEWS README THANKS

%files devel
%{gnuxc_includedir}/pango-1.0
%{gnuxc_libdir}/libpango-1.0.so
%{gnuxc_libdir}/libpangocairo-1.0.so
%{gnuxc_libdir}/libpangoft2-1.0.so
%{gnuxc_libdir}/libpangoxft-1.0.so
%{gnuxc_libdir}/pkgconfig/pango.pc
%{gnuxc_libdir}/pkgconfig/pangocairo.pc
%{gnuxc_libdir}/pkgconfig/pangoft2.pc
%{gnuxc_libdir}/pkgconfig/pangoxft.pc

%files static
%{gnuxc_libdir}/libpango-1.0.a
%{gnuxc_libdir}/libpangocairo-1.0.a
%{gnuxc_libdir}/libpangoft2-1.0.a
%{gnuxc_libdir}/libpangoxft-1.0.a
%{gnuxc_libdir}/pango/1.8.0/modules/pango-arabic-lang.a
%{gnuxc_libdir}/pango/1.8.0/modules/pango-basic-fc.a
%{gnuxc_libdir}/pango/1.8.0/modules/pango-indic-lang.a


%changelog
