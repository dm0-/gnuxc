%?gnuxc_package_header

%global __provides_exclude_from ^%{gnuxc_libdir}/dri/
%global __requires_exclude_from ^%{gnuxc_libdir}/dri/

Name:           gnuxc-mesa
Version:        11.2.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.mesa3d.org/
Source0:        ftp://ftp.freedesktop.org/pub/%{gnuxc_name}/%{version}/%{gnuxc_name}-%{version}.tar.xz

Patch101:       %{gnuxc_name}-%{version}-hurd-port.patch

BuildRequires:  gnuxc-expat-devel
BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-glproto
BuildRequires:  gnuxc-libXdamage-devel
BuildRequires:  gnuxc-libXext-devel
BuildRequires:  gnuxc-nettle-devel
BuildRequires:  gnuxc-pkg-config

BuildRequires:  bison
BuildRequires:  flex

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%setup -q -n %{gnuxc_name}-%{version}
%patch101

%build
%gnuxc_configure \
    --disable-silent-rules \
    --disable-texture-float \
    --disable-xlib-glx \
    --enable-asm \
    --enable-dri --enable-dri3 \
    --enable-egl \
    --enable-gallium-osmesa \
    --enable-gles1 \
    --enable-gles2 \
    --enable-glx \
    --enable-glx-tls \
    --enable-opengl \
    --enable-shared-glapi \
    --with-dri-drivers=swrast \
    --with-gallium-drivers=swrast \
    --with-sha1=libnettle \
    \
    --enable-debug \
    \
    --disable-gbm \
    --disable-nine \
    --disable-selinux \
    --disable-static \
    --disable-sysfs \
    --disable-xa \
    CPPFLAGS=-DPATH_MAX=4096
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/lib{EGL,GL,GLESv1_CM,GLESv2,OSMesa,glapi}.la


%files
%{gnuxc_libdir}/dri
%{gnuxc_libdir}/libEGL.so.1
%{gnuxc_libdir}/libEGL.so.1.0.0
%{gnuxc_libdir}/libGL.so.1
%{gnuxc_libdir}/libGL.so.1.2.0
%{gnuxc_libdir}/libGLESv1_CM.so.1
%{gnuxc_libdir}/libGLESv1_CM.so.1.1.0
%{gnuxc_libdir}/libGLESv2.so.2
%{gnuxc_libdir}/libGLESv2.so.2.0.0
%{gnuxc_libdir}/libOSMesa.so.8
%{gnuxc_libdir}/libOSMesa.so.8.0.0
%{gnuxc_libdir}/libglapi.so.0
%{gnuxc_libdir}/libglapi.so.0.0.0
%{gnuxc_sysconfdir}/drirc
%doc docs/GL3.txt docs/libGL.txt docs/VERSIONS
%license docs/COPYING

%files devel
%{gnuxc_includedir}/EGL
%{gnuxc_includedir}/GLES
%{gnuxc_includedir}/GLES2
%{gnuxc_includedir}/GLES3
%{gnuxc_includedir}/GL/gl.h
%{gnuxc_includedir}/GL/gl_mangle.h
%{gnuxc_includedir}/GL/glcorearb.h
%{gnuxc_includedir}/GL/glext.h
%{gnuxc_includedir}/GL/glx.h
%{gnuxc_includedir}/GL/glx_mangle.h
%{gnuxc_includedir}/GL/glxext.h
%{gnuxc_includedir}/GL/internal/dri_interface.h
%{gnuxc_includedir}/GL/osmesa.h
%{gnuxc_includedir}/GL/wglext.h
%{gnuxc_includedir}/KHR
%{gnuxc_libdir}/libEGL.so
%{gnuxc_libdir}/libGL.so
%{gnuxc_libdir}/libGLESv1_CM.so
%{gnuxc_libdir}/libGLESv2.so
%{gnuxc_libdir}/libOSMesa.so
%{gnuxc_libdir}/libglapi.so
%{gnuxc_libdir}/pkgconfig/dri.pc
%{gnuxc_libdir}/pkgconfig/egl.pc
%{gnuxc_libdir}/pkgconfig/gl.pc
%{gnuxc_libdir}/pkgconfig/glesv1_cm.pc
%{gnuxc_libdir}/pkgconfig/glesv2.pc
%{gnuxc_libdir}/pkgconfig/osmesa.pc
