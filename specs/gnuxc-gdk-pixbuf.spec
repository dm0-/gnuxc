%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/gdk-pixbuf-2.0/
%global __requires_exclude_from ^%{gnuxc_libdir}/gdk-pixbuf-2.0/

Name:           gnuxc-gdk-pixbuf
Version:        2.36.11
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://developer.gnome.org/gdk-pixbuf/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/2.36/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-jasper-devel
BuildRequires:  gnuxc-libpng-devel
BuildRequires:  gnuxc-libX11-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-shared-mime-info-devel
BuildRequires:  gnuxc-tiff-devel

BuildRequires:  glib2-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-jasper-devel
Requires:       gnuxc-libX11-devel
Requires:       gnuxc-tiff-devel

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
%autosetup -n %{gnuxc_name}-%{version}

# Drop a bad prerequisite.
sed -i -e 's, [^ ]*/loaders.cache$,,' thumbnailer/Makefile.in

%build
%gnuxc_configure \
    --disable-nls \
    \
    --disable-rpath \
    --enable-debug \
    --enable-explicit-deps \
    --enable-modules \
    --enable-static \
    --with-libjasper \
    --with-libjpeg \
    --with-libpng \
    --with-libtiff \
    --with-x11 \
    \
    --disable-glibtest \
    --disable-introspection
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/gdk-pixbuf-{csource,pixdata} \
    %{buildroot}%{gnuxc_bindir}/gdk-pixbuf-{query-loaders,thumbnailer}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libgdk_pixbuf{,_xlib}-2.0.la \
 %{buildroot}%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-*.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/thumbnailers

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc %{buildroot}%{gnuxc_mandir}


%files
%dir %{gnuxc_libdir}/gdk-pixbuf-2.0
%dir %{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0
%dir %{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-ani.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-bmp.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-gif.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-icns.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-ico.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-jasper.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-jpeg.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-png.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-pnm.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-qtif.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tga.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tiff.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xbm.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xpm.so
%{gnuxc_libdir}/libgdk_pixbuf-2.0.so.0
%{gnuxc_libdir}/libgdk_pixbuf-2.0.so.0.3611.0
%{gnuxc_libdir}/libgdk_pixbuf_xlib-2.0.so.0
%{gnuxc_libdir}/libgdk_pixbuf_xlib-2.0.so.0.3611.0
%doc AUTHORS NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/gdk-pixbuf-2.0
%{gnuxc_libdir}/libgdk_pixbuf-2.0.so
%{gnuxc_libdir}/libgdk_pixbuf_xlib-2.0.so
%{gnuxc_libdir}/pkgconfig/gdk-pixbuf-2.0.pc
%{gnuxc_libdir}/pkgconfig/gdk-pixbuf-xlib-2.0.pc

%files static
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-ani.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-bmp.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-gif.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-icns.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-ico.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-jasper.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-jpeg.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-png.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-pnm.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-qtif.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tga.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tiff.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xbm.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xpm.a
%{gnuxc_libdir}/libgdk_pixbuf-2.0.a
%{gnuxc_libdir}/libgdk_pixbuf_xlib-2.0.a
