%?gnuxc_package_header

Name:           gnuxc-libXrandr
Version:        1.4.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libXext-devel
BuildRequires:  gnuxc-libXrender-devel
BuildRequires:  gnuxc-randrproto

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libXrender-devel
Requires:       gnuxc-randrproto

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

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXrandr.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXrandr.so.2
%{gnuxc_libdir}/libXrandr.so.2.2.0
%doc AUTHORS ChangeLog COPYING README

%files devel
%{gnuxc_includedir}/X11/extensions/Xrandr.h
%{gnuxc_libdir}/libXrandr.so
%{gnuxc_libdir}/pkgconfig/xrandr.pc

%files static
%{gnuxc_libdir}/libXrandr.a


%changelog
