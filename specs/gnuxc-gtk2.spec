%?gnuxc_package_header

Name:           gnuxc-gtk2
Version:        2.24.30
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://www.gtk.org/
Source0:        http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-%{version}.tar.xz

BuildRequires:  gnuxc-atk-devel
BuildRequires:  gnuxc-gdk-pixbuf-devel
BuildRequires:  gnuxc-libXdamage-devel
BuildRequires:  gnuxc-libXi-devel
BuildRequires:  gnuxc-libXinerama-devel
BuildRequires:  gnuxc-libXrandr-devel
BuildRequires:  gnuxc-pango-devel
BuildRequires:  gnuxc-pkg-config

BuildRequires:  gdk-pixbuf2-devel
BuildRequires:  gettext

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
%setup -q -n gtk+-%{version}

%build
%gnuxc_configure \
    --enable-debug \
    --enable-modules \
    --enable-shm \
    --enable-static \
    --enable-visibility \
    --enable-xinerama \
    --enable-xkb \
    --with-gdktarget=x11 \
    --with-x \
    --with-xinput \
    \
    --disable-cups
%__make -C gtk %{?_smp_mflags} gtk-update-icon-cache.build \
    CC=gcc EXEEXT=.build GMODULE_CFLAGS= \
    GTK_DEP_CFLAGS="$(pkg-config --cflags gdk-pixbuf-2.0)" \
    GDK_PIXBUF_LIBS="$(pkg-config --libs gdk-pixbuf-2.0)"
rm -f gtk/updateiconcache.o
%gnuxc_make %{?_smp_mflags} all \
    GTK_UPDATE_ICON_CACHE="$PWD/gtk/gtk-update-icon-cache.build"

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/gtk-builder-convert \
    %{buildroot}%{gnuxc_bindir}/gtk-demo \
    %{buildroot}%{gnuxc_bindir}/gtk-query-immodules-2.0 \
    %{buildroot}%{gnuxc_bindir}/gtk-update-icon-cache

# We don't need libtool's help.
find %{buildroot}%{gnuxc_libdir} -type f -name '*.la' -delete

# This functionality should be used from the system package.
rm -rf \
    %{buildroot}%{gnuxc_datadir}/{aclocal,themes} \
    %{buildroot}%{gnuxc_datadir}/gtk-2.0 \
    %{buildroot}%{gnuxc_sysconfdir}/gtk-2.0

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc

%find_lang %{gnuxc_name}0
%find_lang %{gnuxc_name}0-properties
cat %{gnuxc_name}0.lang %{gnuxc_name}0-properties.lang |
while read -r l file ; do rm -f %{buildroot}$file ; done


%files
%dir %{gnuxc_libdir}/gtk-2.0
%dir %{gnuxc_libdir}/gtk-2.0/2.10.0
%dir %{gnuxc_libdir}/gtk-2.0/2.10.0/engines
%{gnuxc_libdir}/gtk-2.0/2.10.0/engines/libpixmap.so
%dir %{gnuxc_libdir}/gtk-2.0/2.10.0/immodules
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-am-et.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-cedilla.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-cyrillic-translit.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-inuktitut.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-ipa.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-multipress.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-thai.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-ti-er.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-ti-et.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-viqr.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-xim.so
%dir %{gnuxc_libdir}/gtk-2.0/2.10.0/printbackends
%{gnuxc_libdir}/gtk-2.0/2.10.0/printbackends/libprintbackend-file.so
%{gnuxc_libdir}/gtk-2.0/2.10.0/printbackends/libprintbackend-lpr.so
%dir %{gnuxc_libdir}/gtk-2.0/modules
%{gnuxc_libdir}/gtk-2.0/modules/libferret.so
%{gnuxc_libdir}/gtk-2.0/modules/libgail.so
%{gnuxc_libdir}/libgailutil.so.18
%{gnuxc_libdir}/libgailutil.so.18.0.1
%{gnuxc_libdir}/libgdk-x11-2.0.so.0
%{gnuxc_libdir}/libgdk-x11-2.0.so.0.2400.30
%{gnuxc_libdir}/libgtk-x11-2.0.so.0
%{gnuxc_libdir}/libgtk-x11-2.0.so.0.2400.30
%doc AUTHORS ChangeLog* HACKING INSTALL NEWS* README
%license COPYING

%files devel
%{gnuxc_includedir}/gail-1.0
%{gnuxc_includedir}/gtk-2.0
%{gnuxc_includedir}/gtk-unix-print-2.0
%{gnuxc_libdir}/gtk-2.0/include
%{gnuxc_libdir}/libgailutil.so
%{gnuxc_libdir}/libgdk-x11-2.0.so
%{gnuxc_libdir}/libgtk-x11-2.0.so
%{gnuxc_libdir}/pkgconfig/gail.pc
%{gnuxc_libdir}/pkgconfig/gdk-2.0.pc
%{gnuxc_libdir}/pkgconfig/gdk-x11-2.0.pc
%{gnuxc_libdir}/pkgconfig/gtk+-2.0.pc
%{gnuxc_libdir}/pkgconfig/gtk+-unix-print-2.0.pc
%{gnuxc_libdir}/pkgconfig/gtk+-x11-2.0.pc

%files static
%{gnuxc_libdir}/gtk-2.0/2.10.0/engines/libpixmap.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-am-et.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-cedilla.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-cyrillic-translit.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-inuktitut.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-ipa.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-multipress.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-thai.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-ti-er.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-ti-et.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-viqr.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/immodules/im-xim.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/printbackends/libprintbackend-file.a
%{gnuxc_libdir}/gtk-2.0/2.10.0/printbackends/libprintbackend-lpr.a
%{gnuxc_libdir}/gtk-2.0/modules/libferret.a
%{gnuxc_libdir}/gtk-2.0/modules/libgail.a
%{gnuxc_libdir}/libgailutil.a
%{gnuxc_libdir}/libgdk-x11-2.0.a
%{gnuxc_libdir}/libgtk-x11-2.0.a
