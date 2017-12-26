%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-xextproto
Version:        7.3.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/proto/%{gnuxc_name}-%{version}.tar.bz2

# This is not actually used; it's just for automatic pkg-config dependencies.
BuildRequires:  gnuxc-xproto

Provides:       %{name}-devel = %{version}-%{release}

%description
%{summary}.


%prep
%autosetup -n %{gnuxc_name}-%{version}

# Installed headers include xproto headers.
echo 'Requires: xproto' >> %{gnuxc_name}.pc.in

%build
%gnuxc_configure \
    --disable-specs \
    \
    --enable-strict-compilation
%gnuxc_make_build all

%install
%gnuxc_make_install


%files
%{gnuxc_includedir}/X11/extensions/EVI.h
%{gnuxc_includedir}/X11/extensions/EVIproto.h
%{gnuxc_includedir}/X11/extensions/ag.h
%{gnuxc_includedir}/X11/extensions/agproto.h
%{gnuxc_includedir}/X11/extensions/cup.h
%{gnuxc_includedir}/X11/extensions/cupproto.h
%{gnuxc_includedir}/X11/extensions/dbe.h
%{gnuxc_includedir}/X11/extensions/dbeproto.h
%{gnuxc_includedir}/X11/extensions/dpmsconst.h
%{gnuxc_includedir}/X11/extensions/dpmsproto.h
%{gnuxc_includedir}/X11/extensions/ge.h
%{gnuxc_includedir}/X11/extensions/geproto.h
%{gnuxc_includedir}/X11/extensions/lbx.h
%{gnuxc_includedir}/X11/extensions/lbxproto.h
%{gnuxc_includedir}/X11/extensions/mitmiscconst.h
%{gnuxc_includedir}/X11/extensions/mitmiscproto.h
%{gnuxc_includedir}/X11/extensions/multibufconst.h
%{gnuxc_includedir}/X11/extensions/multibufproto.h
%{gnuxc_includedir}/X11/extensions/secur.h
%{gnuxc_includedir}/X11/extensions/securproto.h
%{gnuxc_includedir}/X11/extensions/shapeconst.h
%{gnuxc_includedir}/X11/extensions/shapeproto.h
%{gnuxc_includedir}/X11/extensions/shapestr.h
%{gnuxc_includedir}/X11/extensions/shm.h
%{gnuxc_includedir}/X11/extensions/shmproto.h
%{gnuxc_includedir}/X11/extensions/shmstr.h
%{gnuxc_includedir}/X11/extensions/syncconst.h
%{gnuxc_includedir}/X11/extensions/syncproto.h
%{gnuxc_includedir}/X11/extensions/syncstr.h
%{gnuxc_includedir}/X11/extensions/xtestconst.h
%{gnuxc_includedir}/X11/extensions/xtestext1const.h
%{gnuxc_includedir}/X11/extensions/xtestext1proto.h
%{gnuxc_includedir}/X11/extensions/xtestproto.h
%{gnuxc_libdir}/pkgconfig/xextproto.pc
%doc ChangeLog README
%license COPYING
