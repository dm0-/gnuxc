%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-xorg-server
Version:        1.18.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/xserver/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-bigreqsproto
BuildRequires:  gnuxc-damageproto
BuildRequires:  gnuxc-fixesproto
BuildRequires:  gnuxc-font-util-devel
BuildRequires:  gnuxc-glproto
BuildRequires:  gnuxc-inputproto
BuildRequires:  gnuxc-libpciaccess-devel
BuildRequires:  gnuxc-xcb-util-keysyms-devel
BuildRequires:  gnuxc-libXfont-devel
BuildRequires:  gnuxc-libXinerama-devel
BuildRequires:  gnuxc-libxkbfile-devel
BuildRequires:  gnuxc-mesa-devel
BuildRequires:  gnuxc-nettle-devel
BuildRequires:  gnuxc-pixman-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-presentproto
BuildRequires:  gnuxc-randrproto
BuildRequires:  gnuxc-renderproto
BuildRequires:  gnuxc-resourceproto
BuildRequires:  gnuxc-videoproto
BuildRequires:  gnuxc-xcmiscproto
BuildRequires:  gnuxc-xf86dgaproto
BuildRequires:  gnuxc-xtrans

Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%setup -q -n %{gnuxc_name}-%{version}
sed configure -i \
    -e '/MONOTONIC_CLOCK=.*cross/s/=.*/=yes/' \
    -e /sysconfigdir=/s/datadir/sysconfdir/
echo 'install-sdkHEADERS:' >> Makefile.in

%build
%gnuxc_configure \
    --disable-silent-rules \
    --disable-suid-wrapper \
    --enable-debug \
    --enable-dga \
    --enable-dpms \
    --enable-glx \
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
    --enable-xinerama \
    --enable-xnest \
    --enable-xorg \
    --enable-xres \
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
    --disable-libdrm \
    --disable-libunwind \
    --disable-record \
    --disable-screensaver \
    --disable-selective-werror \
    --disable-strict-compilation \
    --disable-unit-tests

%install
%gnuxc_make install-headers install-pkgconfigDATA DESTDIR=%{buildroot}
%gnuxc_make -C include install-nodist_sdkHEADERS DESTDIR=%{buildroot}


%files
%{gnuxc_includedir}/xorg
%{gnuxc_libdir}/pkgconfig/xorg-server.pc
%doc ChangeLog README
%license COPYING
