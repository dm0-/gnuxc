%?gnuxc_package_header

Name:           gnuxc-libxcb
Version:        1.12
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://xcb.freedesktop.org/
Source0:        http://xcb.freedesktop.org/dist/%{gnuxc_name}-%{version}.tar.bz2

Patch001:       http://cgit.freedesktop.org/xcb/libxcb/patch/?id=8740a288ca468433141341347aa115b9544891d3#/%{gnuxc_name}-%{version}-fix-tabs.patch

BuildRequires:  gnuxc-libpthread-stubs
BuildRequires:  gnuxc-libXau-devel
BuildRequires:  gnuxc-libXdmcp-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xcb-proto

BuildRequires:  python3

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
%autosetup -n %{gnuxc_name}-%{version} -p1

%build
%gnuxc_configure \
    --disable-devel-docs \
    \
    --enable-composite \
    --enable-damage \
    --enable-dpms \
    --enable-dri2 \
    --enable-dri3 \
    --enable-glx \
    --enable-present \
    --enable-randr \
    --enable-record \
    --enable-render \
    --enable-resource \
    --enable-screensaver \
    --enable-selinux \
    --enable-shape \
    --enable-shm \
    --enable-sync \
    --enable-xevie \
    --enable-xfixes \
    --enable-xfree86-dri \
    --enable-xinerama \
    --enable-xinput \
    --enable-xkb \
    --enable-xprint \
    --enable-xtest \
    --enable-xv \
    --enable-xvmc
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libxcb{,-*}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libxcb.so.1
%{gnuxc_libdir}/libxcb.so.1.1.0
%{gnuxc_libdir}/libxcb-composite.so.0
%{gnuxc_libdir}/libxcb-composite.so.0.0.0
%{gnuxc_libdir}/libxcb-damage.so.0
%{gnuxc_libdir}/libxcb-damage.so.0.0.0
%{gnuxc_libdir}/libxcb-dpms.so.0
%{gnuxc_libdir}/libxcb-dpms.so.0.0.0
%{gnuxc_libdir}/libxcb-dri2.so.0
%{gnuxc_libdir}/libxcb-dri2.so.0.0.0
%{gnuxc_libdir}/libxcb-dri3.so.0
%{gnuxc_libdir}/libxcb-dri3.so.0.0.0
%{gnuxc_libdir}/libxcb-glx.so.0
%{gnuxc_libdir}/libxcb-glx.so.0.0.0
%{gnuxc_libdir}/libxcb-present.so.0
%{gnuxc_libdir}/libxcb-present.so.0.0.0
%{gnuxc_libdir}/libxcb-randr.so.0
%{gnuxc_libdir}/libxcb-randr.so.0.1.0
%{gnuxc_libdir}/libxcb-record.so.0
%{gnuxc_libdir}/libxcb-record.so.0.0.0
%{gnuxc_libdir}/libxcb-render.so.0
%{gnuxc_libdir}/libxcb-render.so.0.0.0
%{gnuxc_libdir}/libxcb-res.so.0
%{gnuxc_libdir}/libxcb-res.so.0.0.0
%{gnuxc_libdir}/libxcb-screensaver.so.0
%{gnuxc_libdir}/libxcb-screensaver.so.0.0.0
%{gnuxc_libdir}/libxcb-shape.so.0
%{gnuxc_libdir}/libxcb-shape.so.0.0.0
%{gnuxc_libdir}/libxcb-shm.so.0
%{gnuxc_libdir}/libxcb-shm.so.0.0.0
%{gnuxc_libdir}/libxcb-sync.so.1
%{gnuxc_libdir}/libxcb-sync.so.1.0.0
%{gnuxc_libdir}/libxcb-xevie.so.0
%{gnuxc_libdir}/libxcb-xevie.so.0.0.0
%{gnuxc_libdir}/libxcb-xf86dri.so.0
%{gnuxc_libdir}/libxcb-xf86dri.so.0.0.0
%{gnuxc_libdir}/libxcb-xfixes.so.0
%{gnuxc_libdir}/libxcb-xfixes.so.0.0.0
%{gnuxc_libdir}/libxcb-xinerama.so.0
%{gnuxc_libdir}/libxcb-xinerama.so.0.0.0
%{gnuxc_libdir}/libxcb-xinput.so.0
%{gnuxc_libdir}/libxcb-xinput.so.0.1.0
%{gnuxc_libdir}/libxcb-xkb.so.1
%{gnuxc_libdir}/libxcb-xkb.so.1.0.0
%{gnuxc_libdir}/libxcb-xprint.so.0
%{gnuxc_libdir}/libxcb-xprint.so.0.0.0
%{gnuxc_libdir}/libxcb-xselinux.so.0
%{gnuxc_libdir}/libxcb-xselinux.so.0.0.0
%{gnuxc_libdir}/libxcb-xtest.so.0
%{gnuxc_libdir}/libxcb-xtest.so.0.0.0
%{gnuxc_libdir}/libxcb-xvmc.so.0
%{gnuxc_libdir}/libxcb-xvmc.so.0.0.0
%{gnuxc_libdir}/libxcb-xv.so.0
%{gnuxc_libdir}/libxcb-xv.so.0.0.0
%doc NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/xcb
%{gnuxc_libdir}/libxcb.so
%{gnuxc_libdir}/libxcb-composite.so
%{gnuxc_libdir}/libxcb-damage.so
%{gnuxc_libdir}/libxcb-dpms.so
%{gnuxc_libdir}/libxcb-dri2.so
%{gnuxc_libdir}/libxcb-dri3.so
%{gnuxc_libdir}/libxcb-glx.so
%{gnuxc_libdir}/libxcb-present.so
%{gnuxc_libdir}/libxcb-randr.so
%{gnuxc_libdir}/libxcb-record.so
%{gnuxc_libdir}/libxcb-render.so
%{gnuxc_libdir}/libxcb-res.so
%{gnuxc_libdir}/libxcb-screensaver.so
%{gnuxc_libdir}/libxcb-shape.so
%{gnuxc_libdir}/libxcb-shm.so
%{gnuxc_libdir}/libxcb-sync.so
%{gnuxc_libdir}/libxcb-xevie.so
%{gnuxc_libdir}/libxcb-xf86dri.so
%{gnuxc_libdir}/libxcb-xfixes.so
%{gnuxc_libdir}/libxcb-xinerama.so
%{gnuxc_libdir}/libxcb-xinput.so
%{gnuxc_libdir}/libxcb-xkb.so
%{gnuxc_libdir}/libxcb-xprint.so
%{gnuxc_libdir}/libxcb-xselinux.so
%{gnuxc_libdir}/libxcb-xtest.so
%{gnuxc_libdir}/libxcb-xvmc.so
%{gnuxc_libdir}/libxcb-xv.so
%{gnuxc_libdir}/pkgconfig/xcb.pc
%{gnuxc_libdir}/pkgconfig/xcb-composite.pc
%{gnuxc_libdir}/pkgconfig/xcb-damage.pc
%{gnuxc_libdir}/pkgconfig/xcb-dpms.pc
%{gnuxc_libdir}/pkgconfig/xcb-dri2.pc
%{gnuxc_libdir}/pkgconfig/xcb-dri3.pc
%{gnuxc_libdir}/pkgconfig/xcb-glx.pc
%{gnuxc_libdir}/pkgconfig/xcb-present.pc
%{gnuxc_libdir}/pkgconfig/xcb-randr.pc
%{gnuxc_libdir}/pkgconfig/xcb-record.pc
%{gnuxc_libdir}/pkgconfig/xcb-render.pc
%{gnuxc_libdir}/pkgconfig/xcb-res.pc
%{gnuxc_libdir}/pkgconfig/xcb-screensaver.pc
%{gnuxc_libdir}/pkgconfig/xcb-shape.pc
%{gnuxc_libdir}/pkgconfig/xcb-shm.pc
%{gnuxc_libdir}/pkgconfig/xcb-sync.pc
%{gnuxc_libdir}/pkgconfig/xcb-xevie.pc
%{gnuxc_libdir}/pkgconfig/xcb-xf86dri.pc
%{gnuxc_libdir}/pkgconfig/xcb-xfixes.pc
%{gnuxc_libdir}/pkgconfig/xcb-xinerama.pc
%{gnuxc_libdir}/pkgconfig/xcb-xinput.pc
%{gnuxc_libdir}/pkgconfig/xcb-xkb.pc
%{gnuxc_libdir}/pkgconfig/xcb-xprint.pc
%{gnuxc_libdir}/pkgconfig/xcb-xselinux.pc
%{gnuxc_libdir}/pkgconfig/xcb-xtest.pc
%{gnuxc_libdir}/pkgconfig/xcb-xvmc.pc
%{gnuxc_libdir}/pkgconfig/xcb-xv.pc

%files static
%{gnuxc_libdir}/libxcb.a
%{gnuxc_libdir}/libxcb-composite.a
%{gnuxc_libdir}/libxcb-damage.a
%{gnuxc_libdir}/libxcb-dpms.a
%{gnuxc_libdir}/libxcb-dri2.a
%{gnuxc_libdir}/libxcb-dri3.a
%{gnuxc_libdir}/libxcb-glx.a
%{gnuxc_libdir}/libxcb-present.a
%{gnuxc_libdir}/libxcb-randr.a
%{gnuxc_libdir}/libxcb-record.a
%{gnuxc_libdir}/libxcb-render.a
%{gnuxc_libdir}/libxcb-res.a
%{gnuxc_libdir}/libxcb-screensaver.a
%{gnuxc_libdir}/libxcb-shape.a
%{gnuxc_libdir}/libxcb-shm.a
%{gnuxc_libdir}/libxcb-sync.a
%{gnuxc_libdir}/libxcb-xevie.a
%{gnuxc_libdir}/libxcb-xf86dri.a
%{gnuxc_libdir}/libxcb-xfixes.a
%{gnuxc_libdir}/libxcb-xinerama.a
%{gnuxc_libdir}/libxcb-xinput.a
%{gnuxc_libdir}/libxcb-xkb.a
%{gnuxc_libdir}/libxcb-xprint.a
%{gnuxc_libdir}/libxcb-xselinux.a
%{gnuxc_libdir}/libxcb-xtest.a
%{gnuxc_libdir}/libxcb-xvmc.a
%{gnuxc_libdir}/libxcb-xv.a
