%?gnuxc_package_header

Name:           gnuxc-libXext
Version:        1.3.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libX11-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xextproto

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
    --disable-specs \
    \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXext.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXext.so.6
%{gnuxc_libdir}/libXext.so.6.4.0
%doc AUTHORS ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/extensions/dpms.h
%{gnuxc_includedir}/X11/extensions/extutil.h
%{gnuxc_includedir}/X11/extensions/MITMisc.h
%{gnuxc_includedir}/X11/extensions/multibuf.h
%{gnuxc_includedir}/X11/extensions/security.h
%{gnuxc_includedir}/X11/extensions/shape.h
%{gnuxc_includedir}/X11/extensions/sync.h
%{gnuxc_includedir}/X11/extensions/Xag.h
%{gnuxc_includedir}/X11/extensions/Xcup.h
%{gnuxc_includedir}/X11/extensions/Xdbe.h
%{gnuxc_includedir}/X11/extensions/XEVI.h
%{gnuxc_includedir}/X11/extensions/Xext.h
%{gnuxc_includedir}/X11/extensions/Xge.h
%{gnuxc_includedir}/X11/extensions/XLbx.h
%{gnuxc_includedir}/X11/extensions/XShm.h
%{gnuxc_includedir}/X11/extensions/xtestext1.h
%{gnuxc_libdir}/libXext.so
%{gnuxc_libdir}/pkgconfig/xext.pc

%files static
%{gnuxc_libdir}/libXext.a
