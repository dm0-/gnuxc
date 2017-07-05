%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/X11/locale/common/
%global __requires_exclude_from ^%{gnuxc_libdir}/X11/locale/common/

Name:           gnuxc-libX11
Version:        1.6.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-inputproto
BuildRequires:  gnuxc-kbproto
BuildRequires:  gnuxc-libxcb-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xextproto
BuildRequires:  gnuxc-xtrans

BuildRequires:  perl
BuildRequires:  xorg-x11-proto-devel

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
    --disable-specs \
    \
    --disable-silent-rules \
    --enable-ipv6 \
    --enable-loadable-i18n \
    --enable-loadable-xcursor \
    --enable-local-transport \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
    --enable-tcp-transport \
    --enable-unix-transport \
    --enable-xlocaledir \
    --enable-xthreads \
    --with-perl
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f \
    %{buildroot}%{gnuxc_libdir}/libX11{,-xcb}.la \
    %{buildroot}%{gnuxc_libdir}/X11/locale/common/x*.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_datadir}/X11/locale
%{gnuxc_datadir}/X11/Xcms.txt
%{gnuxc_datadir}/X11/XErrorDB
%{gnuxc_libdir}/libX11.so.6
%{gnuxc_libdir}/libX11.so.6.3.0
%{gnuxc_libdir}/libX11-xcb.so.1
%{gnuxc_libdir}/libX11-xcb.so.1.0.0
%dir %{gnuxc_libdir}/X11
%dir %{gnuxc_libdir}/X11/locale
%dir %{gnuxc_libdir}/X11/locale/common
%{gnuxc_libdir}/X11/locale/common/ximcp.so.2
%{gnuxc_libdir}/X11/locale/common/ximcp.so.2.0.0
%{gnuxc_libdir}/X11/locale/common/xlcDef.so.2
%{gnuxc_libdir}/X11/locale/common/xlcDef.so.2.0.0
%{gnuxc_libdir}/X11/locale/common/xlcUTF8Load.so.2
%{gnuxc_libdir}/X11/locale/common/xlcUTF8Load.so.2.0.0
%{gnuxc_libdir}/X11/locale/common/xlibi18n.so.2
%{gnuxc_libdir}/X11/locale/common/xlibi18n.so.2.0.0
%{gnuxc_libdir}/X11/locale/common/xomGeneric.so.2
%{gnuxc_libdir}/X11/locale/common/xomGeneric.so.2.0.0
%doc AUTHORS ChangeLog NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/cursorfont.h
%{gnuxc_includedir}/X11/ImUtil.h
%{gnuxc_includedir}/X11/Xcms.h
%{gnuxc_includedir}/X11/XKBlib.h
%{gnuxc_includedir}/X11/Xlib.h
%{gnuxc_includedir}/X11/Xlib-xcb.h
%{gnuxc_includedir}/X11/XlibConf.h
%{gnuxc_includedir}/X11/Xlibint.h
%{gnuxc_includedir}/X11/Xlocale.h
%{gnuxc_includedir}/X11/Xregion.h
%{gnuxc_includedir}/X11/Xresource.h
%{gnuxc_includedir}/X11/Xutil.h
%{gnuxc_libdir}/libX11.so
%{gnuxc_libdir}/libX11-xcb.so
%{gnuxc_libdir}/pkgconfig/x11.pc
%{gnuxc_libdir}/pkgconfig/x11-xcb.pc
%{gnuxc_libdir}/X11/locale/common/ximcp.so
%{gnuxc_libdir}/X11/locale/common/xlcDef.so
%{gnuxc_libdir}/X11/locale/common/xlcUTF8Load.so
%{gnuxc_libdir}/X11/locale/common/xlibi18n.so
%{gnuxc_libdir}/X11/locale/common/xomGeneric.so

%files static
%{gnuxc_libdir}/libX11.a
%{gnuxc_libdir}/libX11-xcb.a
%{gnuxc_libdir}/X11/locale/common/ximcp.a
%{gnuxc_libdir}/X11/locale/common/xlcDef.a
%{gnuxc_libdir}/X11/locale/common/xlcUTF8Load.a
%{gnuxc_libdir}/X11/locale/common/xlibi18n.a
%{gnuxc_libdir}/X11/locale/common/xomGeneric.a
