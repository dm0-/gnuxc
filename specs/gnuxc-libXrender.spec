%?gnuxc_package_header

Name:           gnuxc-libXrender
Version:        0.9.8
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libX11-devel
BuildRequires:  gnuxc-renderproto

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libX11-devel
Requires:       gnuxc-renderproto

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
rm -f %{buildroot}%{gnuxc_libdir}/libXrender.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}


%files
%{gnuxc_libdir}/libXrender.so.1
%{gnuxc_libdir}/libXrender.so.1.3.0
%doc AUTHORS ChangeLog COPYING README

%files devel
%{gnuxc_includedir}/X11/extensions/Xrender.h
%{gnuxc_libdir}/libXrender.so
%{gnuxc_libdir}/pkgconfig/xrender.pc

%files static
%{gnuxc_libdir}/libXrender.a


%changelog
