%?gnuxc_package_header

Name:           gnuxc-libXaw
Version:        1.0.13
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libXmu-devel
BuildRequires:  gnuxc-libXpm-devel
BuildRequires:  gnuxc-pkg-config

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libXmu-devel
Requires:       gnuxc-libXpm-devel

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
    --disable-specs \
    \
    --disable-silent-rules \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
    --enable-xaw{6,7}
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXaw{6,7}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXaw.so.6
%{gnuxc_libdir}/libXaw.so.7
%{gnuxc_libdir}/libXaw6.so.6
%{gnuxc_libdir}/libXaw6.so.6.0.1
%{gnuxc_libdir}/libXaw7.so.7
%{gnuxc_libdir}/libXaw7.so.7.0.0
%doc ChangeLog README
%license COPYING

%files devel
%{gnuxc_includedir}/X11/Xaw
%{gnuxc_libdir}/libXaw.so
%{gnuxc_libdir}/libXaw6.so
%{gnuxc_libdir}/libXaw7.so
%{gnuxc_libdir}/pkgconfig/xaw6.pc
%{gnuxc_libdir}/pkgconfig/xaw7.pc

%files static
%{gnuxc_libdir}/libXaw6.a
%{gnuxc_libdir}/libXaw7.a


%changelog
