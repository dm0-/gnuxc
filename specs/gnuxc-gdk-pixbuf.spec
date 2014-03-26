%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/gdk-pixbuf-2.0/
%global __requires_exclude_from ^%{gnuxc_libdir}/gdk-pixbuf-2.0/

Name:           gnuxc-gdk-pixbuf
Version:        2.30.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
Group:          System Environment/Libraries
URL:            http://developer.gnome.org/gdk-pixbuf/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/2.30/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-libjpeg-turbo-devel
BuildRequires:  gnuxc-libpng-devel
BuildRequires:  gnuxc-libX11-devel
BuildRequires:  gnuxc-tiff-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glib-devel
Requires:       gnuxc-libjpeg-turbo-devel
Requires:       gnuxc-libpng-devel
Requires:       gnuxc-libX11-devel
Requires:       gnuxc-tiff-devel

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
    --disable-nls \
    \
    --disable-rpath \
    --disable-silent-rules \
    --enable-debug \
    --enable-explicit-deps \
    --enable-gio-sniffing \
    --enable-modules \
    --enable-static \
    --with-libjpeg \
    --with-libpng \
    --with-libtiff \
    --with-x11 \
    \
    --disable-glibtest \
    --disable-introspection \
    --without-libjasper
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/gdk-pixbuf-{csource,pixdata,query-loaders}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libgdk_pixbuf{,_xlib}-2.0.la \
 %{buildroot}%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-*.la

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
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-jpeg.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-pcx.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-png.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-pnm.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-qtif.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-ras.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tga.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tiff.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-wbmp.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xbm.so
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xpm.so
%{gnuxc_libdir}/libgdk_pixbuf-2.0.so.0
%{gnuxc_libdir}/libgdk_pixbuf-2.0.so.0.3000.7
%{gnuxc_libdir}/libgdk_pixbuf_xlib-2.0.so.0
%{gnuxc_libdir}/libgdk_pixbuf_xlib-2.0.so.0.3000.7
%doc AUTHORS COPYING NEWS README

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
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-jpeg.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-pcx.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-png.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-pnm.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-qtif.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-ras.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tga.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-tiff.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-wbmp.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xbm.a
%{gnuxc_libdir}/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xpm.a
%{gnuxc_libdir}/libgdk_pixbuf-2.0.a
%{gnuxc_libdir}/libgdk_pixbuf_xlib-2.0.a


%changelog
