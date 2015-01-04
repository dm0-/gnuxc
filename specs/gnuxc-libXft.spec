%?gnuxc_package_header

Name:           gnuxc-libXft
Version:        2.3.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-fontconfig-devel
BuildRequires:  gnuxc-libXrender-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-fontconfig-devel
Requires:       gnuxc-libXrender-devel

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
rm -f %{buildroot}%{gnuxc_libdir}/libXft.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXft.so.2
%{gnuxc_libdir}/libXft.so.%{version}
%doc AUTHORS ChangeLog COPYING NEWS README

%files devel
%{gnuxc_includedir}/X11/Xft
%{gnuxc_libdir}/libXft.so
%{gnuxc_libdir}/pkgconfig/xft.pc

%files static
%{gnuxc_libdir}/libXft.a


%changelog
