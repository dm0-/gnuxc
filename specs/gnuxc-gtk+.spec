%?gnuxc_package_header

Name:           gnuxc-gtk+
Version:        3.18.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
Group:          System Environment/Libraries
URL:            http://www.gtk.org/
Source0:        http://ftp.gnome.org/pub/gnome/sources/gtk+/3.18/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-atk-devel
BuildRequires:  gnuxc-gdk-pixbuf-devel
BuildRequires:  gnuxc-libepoxy-devel
BuildRequires:  gnuxc-libXi-devel
BuildRequires:  gnuxc-libXinerama-devel
BuildRequires:  gnuxc-libXrandr-devel
BuildRequires:  gnuxc-pango-devel
BuildRequires:  gnuxc-pkg-config

BuildRequires:  gettext
BuildRequires:  gobject-introspection-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-atk-devel
Requires:       gnuxc-gdk-pixbuf-devel
Requires:       gnuxc-libXdamage-devel
Requires:       gnuxc-libXi-devel
Requires:       gnuxc-libXinerama-devel
Requires:       gnuxc-libXrandr-devel
Requires:       gnuxc-pango-devel

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
sed -i -e 's/ atk-bridge-2.0//' configure.ac
sed -i -e '/atk[-_]bridge/d' gtk/a11y/gtkaccessibility.c
autoreconf -fi

# Seriously disable rpaths.
sed -i -e 's/\(need_relink\)=yes/\1=no/' build-aux/ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__BAD_LIBTOOL__/' configure

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-debug \
    --enable-modules \
    --enable-static \
    --enable-x11-backend \
    --enable-xdamage \
    --enable-xfixes \
    --enable-xinerama \
    --enable-xkb \
    --enable-xrandr \
    --with-x \
    \
    --disable-colord \
    --disable-glibtest \
    --disable-schemas-compile \
    --disable-xcomposite
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{gtk,gtk3}-*

# We don't need libtool's help.
find %{buildroot}%{gnuxc_libdir} -type f -name '*.la' -delete

# This functionality should be used from the system package.
rm -rf \
    %{buildroot}%{gnuxc_datadir}/{aclocal,applications,icons,themes} \
    %{buildroot}%{gnuxc_datadir}/{glib-2.0,gtk-3.0} \
    %{buildroot}%{gnuxc_sysconfdir}/gtk-3.0

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc %{buildroot}%{gnuxc_mandir}

%find_lang gtk30
%find_lang gtk30-properties
cat gtk30.lang gtk30-properties.lang |
while read -r l file ; do rm -f %{buildroot}$file ; done


%files
%dir %{gnuxc_libdir}/gtk-3.0
%dir %{gnuxc_libdir}/gtk-3.0/3.0.0
%dir %{gnuxc_libdir}/gtk-3.0/3.0.0/immodules
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-am-et.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-cedilla.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-cyrillic-translit.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-inuktitut.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-ipa.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-multipress.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-thai.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-ti-er.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-ti-et.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-viqr.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-xim.so
%dir %{gnuxc_libdir}/gtk-3.0/3.0.0/printbackends
%{gnuxc_libdir}/gtk-3.0/3.0.0/printbackends/libprintbackend-file.so
%{gnuxc_libdir}/gtk-3.0/3.0.0/printbackends/libprintbackend-lpr.so
%{gnuxc_libdir}/libgailutil-3.so.0
%{gnuxc_libdir}/libgailutil-3.so.0.0.0
%{gnuxc_libdir}/libgdk-3.so.0
%{gnuxc_libdir}/libgdk-3.so.0.1800.5
%{gnuxc_libdir}/libgtk-3.so.0
%{gnuxc_libdir}/libgtk-3.so.0.1800.5
%doc AUTHORS ChangeLog* HACKING INSTALL NEWS* README
%license COPYING

%files devel
%{gnuxc_includedir}/gail-3.0
%{gnuxc_includedir}/gtk-3.0
%{gnuxc_libdir}/libgailutil-3.so
%{gnuxc_libdir}/libgdk-3.so
%{gnuxc_libdir}/libgtk-3.so
%{gnuxc_libdir}/pkgconfig/gail-3.0.pc
%{gnuxc_libdir}/pkgconfig/gdk-3.0.pc
%{gnuxc_libdir}/pkgconfig/gdk-x11-3.0.pc
%{gnuxc_libdir}/pkgconfig/gtk+-3.0.pc
%{gnuxc_libdir}/pkgconfig/gtk+-unix-print-3.0.pc
%{gnuxc_libdir}/pkgconfig/gtk+-x11-3.0.pc

%files static
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-am-et.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-cedilla.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-cyrillic-translit.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-inuktitut.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-ipa.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-multipress.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-thai.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-ti-er.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-ti-et.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-viqr.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/immodules/im-xim.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/printbackends/libprintbackend-file.a
%{gnuxc_libdir}/gtk-3.0/3.0.0/printbackends/libprintbackend-lpr.a
%{gnuxc_libdir}/libgailutil-3.a
%{gnuxc_libdir}/libgdk-3.a
%{gnuxc_libdir}/libgtk-3.a


%changelog
