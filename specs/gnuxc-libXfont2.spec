%?gnuxc_package_header

Name:           gnuxc-libXfont2
Version:        2.0.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-bzip2-devel
BuildRequires:  gnuxc-freetype-devel
BuildRequires:  gnuxc-libfontenc-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xtrans

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
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --enable-{bdf,pcf,snf}format \
    --enable-builtins \
    --enable-devel-docs \
    --enable-fc \
    --enable-freetype \
    --enable-ipv6 \
    --enable-local-transport \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
    --enable-tcp-transport \
    --enable-unix-transport \
    --with-bzip2
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXfont2.la


%files
%{gnuxc_libdir}/libXfont2.so.2
%{gnuxc_libdir}/libXfont2.so.2.0.0
%doc AUTHORS ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/fonts/libxfont2.h
%{gnuxc_libdir}/libXfont2.so
%{gnuxc_libdir}/pkgconfig/xfont2.pc

%files static
%{gnuxc_libdir}/libXfont2.a
