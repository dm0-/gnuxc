%?gnuxc_package_header

Name:           gnuxc-libXau
Version:        1.0.8
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xproto

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
    --disable-silent-rules \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
    --enable-xthreads
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXau.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXau.so.6
%{gnuxc_libdir}/libXau.so.6.0.0
%doc AUTHORS ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/Xauth.h
%{gnuxc_libdir}/libXau.so
%{gnuxc_libdir}/pkgconfig/xau.pc

%files static
%{gnuxc_libdir}/libXau.a
