%?gnuxc_package_header

Name:           gnuxc-fontconfig
Version:        2.12.6
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT and Public Domain and UCD
URL:            http://fontconfig.org/
Source0:        http://www.freedesktop.org/software/%{gnuxc_name}/release/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-freetype-devel
BuildRequires:  gnuxc-libxml2-devel
BuildRequires:  gnuxc-pkg-config

BuildRequires:  gperf
BuildRequires:  python3

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
    --disable-docs \
    \
    --enable-iconv \
    --enable-libxml2 \
    --enable-static
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/fc-*

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libfontconfig.la


%files
%{gnuxc_datadir}/fontconfig
%{gnuxc_datadir}/xml/fontconfig
%{gnuxc_libdir}/libfontconfig.so.1
%{gnuxc_libdir}/libfontconfig.so.1.10.1
%{gnuxc_sysconfdir}/fonts
%doc AUTHORS ChangeLog NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/fontconfig
%{gnuxc_libdir}/libfontconfig.so
%{gnuxc_libdir}/pkgconfig/fontconfig.pc

%files static
%{gnuxc_libdir}/libfontconfig.a
