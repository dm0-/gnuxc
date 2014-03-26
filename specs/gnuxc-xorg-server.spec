%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/xorg/modules/
%global __requires_exclude_from ^%{gnuxc_libdir}/xorg/modules/

Name:           gnuxc-xorg-server
Version:        1.15.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          User Interface/X
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/xserver/%{gnuxc_name}-%{version}.tar.bz2

Patch101:       %{gnuxc_name}-%{version}-optional-xinerama.patch

BuildRequires:  gnuxc-bigreqsproto
BuildRequires:  gnuxc-damageproto
BuildRequires:  gnuxc-fixesproto
BuildRequires:  gnuxc-font-util-devel
BuildRequires:  gnuxc-libpciaccess-devel
BuildRequires:  gnuxc-libxcb-devel
BuildRequires:  gnuxc-libXdmcp-devel
BuildRequires:  gnuxc-libXext-devel
BuildRequires:  gnuxc-libXfont-devel
BuildRequires:  gnuxc-libxkbfile-devel
BuildRequires:  gnuxc-nettle-devel
BuildRequires:  gnuxc-pixman-devel
BuildRequires:  gnuxc-presentproto
BuildRequires:  gnuxc-randrproto
BuildRequires:  gnuxc-renderproto
BuildRequires:  gnuxc-videoproto
BuildRequires:  gnuxc-xcmiscproto
BuildRequires:  gnuxc-xf86dgaproto

Requires:       gnuxc-libX11

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

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
%patch101
echo 'install-sdkHEADERS:' >> Makefile.in

%build
%gnuxc_configure \
    --disable-docs --disable-devel-docs \
    \
    --disable-silent-rules \
    --enable-debug \
    --enable-dga \
    --enable-dpms \
    --enable-int10-module \
    --enable-ipv6 \
    --enable-local-transport \
    --enable-mitshm \
    --enable-pciaccess \
    --enable-present \
    --enable-secure-rpc \
    --enable-static \
    --enable-tcp-transport \
    --enable-unix-transport \
    --enable-vbe \
    --enable-vgahw \
    --enable-visibility \
    --enable-xcsecurity \
    --enable-xdm-auth-1 \
    --enable-xdmcp \
    --enable-xfree86-utils \
    --enable-xnest \
    --enable-xorg \
    --enable-xv \
    --enable-xvfb \
    --with-sha1=libnettle \
    --with-xkb-output='${sharedstatedir}/X11/xkb' \
    \
    --disable-aiglx \
    --disable-composite \
    --disable-dri \
    --disable-dri2 \
    --disable-dri3 \
    --disable-glx \
    --disable-record \
    --disable-screensaver \
    --disable-selective-werror \
    --disable-xinerama \
    --disable-xres
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install install-headers

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{cvt,gtf,X,Xnest,Xorg,Xvfb}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/xorg/modules/{lib*.la,multimedia/*_drv.la}

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%dir %{gnuxc_libdir}/xorg
%dir %{gnuxc_libdir}/xorg/modules
%dir %{gnuxc_libdir}/xorg/modules/multimedia
%{gnuxc_libdir}/xorg/protocol.txt
%{gnuxc_libdir}/xorg/modules/libexa.so
%{gnuxc_libdir}/xorg/modules/libfbdevhw.so
%{gnuxc_libdir}/xorg/modules/libfb.so
%{gnuxc_libdir}/xorg/modules/libint10.so
%{gnuxc_libdir}/xorg/modules/libshadowfb.so
%{gnuxc_libdir}/xorg/modules/libshadow.so
%{gnuxc_libdir}/xorg/modules/libvbe.so
%{gnuxc_libdir}/xorg/modules/libvgahw.so
%{gnuxc_libdir}/xorg/modules/libwfb.so
%{gnuxc_libdir}/xorg/modules/multimedia/bt829_drv.so
%{gnuxc_libdir}/xorg/modules/multimedia/fi1236_drv.so
%{gnuxc_libdir}/xorg/modules/multimedia/msp3430_drv.so
%{gnuxc_libdir}/xorg/modules/multimedia/tda8425_drv.so
%{gnuxc_libdir}/xorg/modules/multimedia/tda9850_drv.so
%{gnuxc_libdir}/xorg/modules/multimedia/tda9885_drv.so
%{gnuxc_libdir}/xorg/modules/multimedia/uda1380_drv.so
%{gnuxc_sharedstatedir}/X11
%doc ChangeLog COPYING README

%files devel
%{gnuxc_includedir}/xorg
%{gnuxc_libdir}/pkgconfig/xorg-server.pc

%files static
%{gnuxc_libdir}/xorg/modules/libexa.a
%{gnuxc_libdir}/xorg/modules/libfb.a
%{gnuxc_libdir}/xorg/modules/libfbdevhw.a
%{gnuxc_libdir}/xorg/modules/libint10.a
%{gnuxc_libdir}/xorg/modules/libshadow.a
%{gnuxc_libdir}/xorg/modules/libshadowfb.a
%{gnuxc_libdir}/xorg/modules/libvbe.a
%{gnuxc_libdir}/xorg/modules/libvgahw.a
%{gnuxc_libdir}/xorg/modules/libwfb.a
%{gnuxc_libdir}/xorg/modules/multimedia/bt829_drv.a
%{gnuxc_libdir}/xorg/modules/multimedia/fi1236_drv.a
%{gnuxc_libdir}/xorg/modules/multimedia/msp3430_drv.a
%{gnuxc_libdir}/xorg/modules/multimedia/tda8425_drv.a
%{gnuxc_libdir}/xorg/modules/multimedia/tda9850_drv.a
%{gnuxc_libdir}/xorg/modules/multimedia/tda9885_drv.a
%{gnuxc_libdir}/xorg/modules/multimedia/uda1380_drv.a


%changelog
