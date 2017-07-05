%?gnuxc_package_header

Name:           gnuxc-cairo
Version:        1.14.10
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2 or MPLv1.1
URL:            http://cairographics.org/
Source0:        http://cairographics.org/releases/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-binutils-devel
BuildRequires:  gnuxc-fontconfig-devel
BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-libXext-devel
BuildRequires:  gnuxc-libXrender-devel
BuildRequires:  gnuxc-pixman-devel
BuildRequires:  gnuxc-pkg-config

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-binutils-devel

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
    --enable-fc \
    --enable-ft \
    --enable-gobject \
    --enable-interpreter \
    --enable-pdf \
    --enable-png \
    --enable-ps \
    --enable-pthread \
    --enable-script \
    --enable-svg \
    --enable-symbol-lookup \
    --enable-tee \
    --enable-test-surfaces \
    --enable-trace \
    --enable-xcb \
    --enable-xcb-shm \
    --enable-xlib \
    --enable-xlib-xcb \
    --enable-xlib-xrender \
    --enable-xml \
    --with-x \
    CPPFLAGS='-DMAP_NORESERVE=0' \
    \
    --disable-drm \
    --disable-gallium \
    --disable-qt \
    --disable-vg
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/cairo-{sphinx,trace}

# We don't need libtool's help.
rm -f \
    %{buildroot}%{gnuxc_libdir}/libcairo{,-gobject,-script-interpreter}.la \
    %{buildroot}%{gnuxc_libdir}/cairo/{cairo-{fdr,sphinx},libcairo-trace}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc


%files
%dir %{gnuxc_libdir}/cairo
%{gnuxc_libdir}/cairo/cairo-fdr.so.0
%{gnuxc_libdir}/cairo/cairo-fdr.so.0.0.0
%{gnuxc_libdir}/cairo/cairo-sphinx.so.0
%{gnuxc_libdir}/cairo/cairo-sphinx.so.0.0.0
%{gnuxc_libdir}/cairo/libcairo-trace.so.0
%{gnuxc_libdir}/cairo/libcairo-trace.so.0.0.0
%{gnuxc_libdir}/libcairo.so.2
%{gnuxc_libdir}/libcairo.so.2.11400.10
%{gnuxc_libdir}/libcairo-gobject.so.2
%{gnuxc_libdir}/libcairo-gobject.so.2.11400.10
%{gnuxc_libdir}/libcairo-script-interpreter.so.2
%{gnuxc_libdir}/libcairo-script-interpreter.so.2.11400.10
%doc AUTHORS BIBLIOGRAPHY BUGS ChangeLog* CODING_STYLE HACKING
%doc KNOWN_ISSUES NEWS PORTING_GUIDE README RELEASING
%license COPYING COPYING-LGPL-2.1 COPYING-MPL-1.1

%files devel
%{gnuxc_includedir}/cairo
%{gnuxc_libdir}/cairo/cairo-fdr.so
%{gnuxc_libdir}/cairo/cairo-sphinx.so
%{gnuxc_libdir}/cairo/libcairo-trace.so
%{gnuxc_libdir}/libcairo.so
%{gnuxc_libdir}/libcairo-gobject.so
%{gnuxc_libdir}/libcairo-script-interpreter.so
%{gnuxc_libdir}/pkgconfig/cairo-fc.pc
%{gnuxc_libdir}/pkgconfig/cairo-ft.pc
%{gnuxc_libdir}/pkgconfig/cairo-gobject.pc
%{gnuxc_libdir}/pkgconfig/cairo.pc
%{gnuxc_libdir}/pkgconfig/cairo-pdf.pc
%{gnuxc_libdir}/pkgconfig/cairo-png.pc
%{gnuxc_libdir}/pkgconfig/cairo-ps.pc
%{gnuxc_libdir}/pkgconfig/cairo-script.pc
%{gnuxc_libdir}/pkgconfig/cairo-svg.pc
%{gnuxc_libdir}/pkgconfig/cairo-tee.pc
%{gnuxc_libdir}/pkgconfig/cairo-xcb.pc
%{gnuxc_libdir}/pkgconfig/cairo-xcb-shm.pc
%{gnuxc_libdir}/pkgconfig/cairo-xlib.pc
%{gnuxc_libdir}/pkgconfig/cairo-xlib-xcb.pc
%{gnuxc_libdir}/pkgconfig/cairo-xlib-xrender.pc
%{gnuxc_libdir}/pkgconfig/cairo-xml.pc

%files static
%{gnuxc_libdir}/cairo/cairo-fdr.a
%{gnuxc_libdir}/cairo/cairo-sphinx.a
%{gnuxc_libdir}/cairo/libcairo-trace.a
%{gnuxc_libdir}/libcairo.a
%{gnuxc_libdir}/libcairo-gobject.a
%{gnuxc_libdir}/libcairo-script-interpreter.a
