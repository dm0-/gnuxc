%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/pango/
%global __requires_exclude_from ^%{gnuxc_libdir}/pango/

Name:           gnuxc-pango
Version:        1.40.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://developer.gnome.org/pango/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/1.40/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-cairo-devel
BuildRequires:  gnuxc-harfbuzz-devel
BuildRequires:  gnuxc-libXft-devel
BuildRequires:  gnuxc-pkg-config

BuildRequires:  glib2-devel

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
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-debug \
    --enable-static \
    --with-cairo \
    --with-xft \
    \
    --disable-introspection
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/pango-view

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpango{,cairo,ft2,xft}-1.0.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpango-1.0.so.0
%{gnuxc_libdir}/libpango-1.0.so.0.4000.1
%{gnuxc_libdir}/libpangocairo-1.0.so.0
%{gnuxc_libdir}/libpangocairo-1.0.so.0.4000.1
%{gnuxc_libdir}/libpangoft2-1.0.so.0
%{gnuxc_libdir}/libpangoft2-1.0.so.0.4000.1
%{gnuxc_libdir}/libpangoxft-1.0.so.0
%{gnuxc_libdir}/libpangoxft-1.0.so.0.4000.1
%doc AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README THANKS
%license COPYING

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
