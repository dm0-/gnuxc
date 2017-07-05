%?gnuxc_package_header

Name:           gnuxc-libpciaccess
Version:        0.13.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-zlib-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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
    --with-zlib
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpciaccess.la


%files
%{gnuxc_libdir}/libpciaccess.so.0
%{gnuxc_libdir}/libpciaccess.so.0.11.1
%doc AUTHORS ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/pciaccess.h
%{gnuxc_libdir}/libpciaccess.so
%{gnuxc_libdir}/pkgconfig/pciaccess.pc

%files static
%{gnuxc_libdir}/libpciaccess.a
