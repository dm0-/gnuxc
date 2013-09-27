%?gnuxc_package_header

Name:           gnuxc-freetype
Version:        2.5.0.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        FTL or GPLv2+
Group:          System Environment/Libraries
URL:            http://www.freetype.org/
Source0:        http://download.savannah.gnu.org/releases/freetype/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-bzip2-devel
BuildRequires:  gnuxc-libpng-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-bzip2-devel

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
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --with-bzip2 \
    --with-old-mac-fonts \
    --with-png \
    --with-zlib \
    LIBPNG_CFLAGS="`%{gnuxc_target}-libpng-config --cflags`" \
    LIBPNG_LDFLAGS="`%{gnuxc_target}-libpng-config --ldflags`"
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/freetype-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-freetype-config

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libfreetype.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal


%files
%{gnuxc_libdir}/libfreetype.so.6
%{gnuxc_libdir}/libfreetype.so.6.10.2
%doc ChangeLog* docs README*

%files devel
%{_bindir}/%{gnuxc_target}-freetype-config
%{gnuxc_root}/bin/freetype-config
%{gnuxc_includedir}/freetype2
%{gnuxc_includedir}/ft2build.h
%{gnuxc_libdir}/libfreetype.so
%{gnuxc_libdir}/pkgconfig/freetype2.pc

%files static
%{gnuxc_libdir}/libfreetype.a


%changelog
