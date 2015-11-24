%?gnuxc_package_header

Name:           gnuxc-libXinerama
Version:        1.1.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libXext-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xineramaproto

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libXext-devel
Requires:       gnuxc-xineramaproto

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
rm -f %{buildroot}%{gnuxc_libdir}/libXinerama.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXinerama.so.1
%{gnuxc_libdir}/libXinerama.so.1.0.0
%doc ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/extensions/panoramiXext.h
%{gnuxc_includedir}/X11/extensions/Xinerama.h
%{gnuxc_libdir}/libXinerama.so
%{gnuxc_libdir}/pkgconfig/xinerama.pc

%files static
%{gnuxc_libdir}/libXinerama.a


%changelog
