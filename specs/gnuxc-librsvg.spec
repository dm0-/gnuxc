%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/gdk-pixbuf-2.0/
%global __requires_exclude_from ^%{gnuxc_libdir}/gdk-pixbuf-2.0/

Name:           gnuxc-librsvg
Version:        2.40.16
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://developer.gnome.org/rsvg/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/2.40/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gdk-pixbuf-devel
BuildRequires:  gnuxc-libcroco-devel
BuildRequires:  gnuxc-pango-devel
BuildRequires:  gnuxc-pkg-config

BuildRequires:  gdk-pixbuf2
BuildRequires:  glib2-devel

Requires:       gnuxc-gdk-pixbuf

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libcroco-devel
Requires:       gnuxc-pango-devel

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
    --enable-pixbuf-loader \
    --enable-tools \
    \
    --disable-vala --disable-introspection
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/rsvg-{convert,view-3}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/librsvg-2.la \
 %{buildroot}%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-*.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-svg.so
%{gnuxc_libdir}/librsvg-2.so.2
%{gnuxc_libdir}/librsvg-2.so.%{version}
%doc AUTHORS ChangeLog NEWS README TODO
%license COPYING COPYING.LIB

%files devel
%{gnuxc_includedir}/librsvg-2.0
%{gnuxc_libdir}/librsvg-2.so
%{gnuxc_libdir}/pkgconfig/librsvg-2.0.pc

%files static
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-svg.a
%{gnuxc_libdir}/librsvg-2.a
