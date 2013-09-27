%?gnuxc_package_header

Name:           gnuxc-fontconfig
Version:        2.10.95
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT and Public Domain and UCD
Group:          System Environment/Libraries
URL:            http://fontconfig.org/
Source0:        http://www.freedesktop.org/software/%{gnuxc_name}/release/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-freetype-devel
BuildRequires:  gnuxc-libxml2-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-freetype-devel
Requires:       gnuxc-libxml2-devel

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
    --disable-docs \
    \
    --disable-silent-rules \
    --enable-iconv \
    --enable-libxml2
%gnuxc_make %{?_smp_mflags} all \
    CPPFLAGS=-DPATH_MAX=4096

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
%{gnuxc_libdir}/libfontconfig.so.1.7.0
%{gnuxc_sysconfdir}/fonts
%doc AUTHORS ChangeLog COPYING NEWS README

%files devel
%{gnuxc_includedir}/fontconfig
%{gnuxc_libdir}/libfontconfig.so
%{gnuxc_libdir}/pkgconfig/fontconfig.pc

%files static
%{gnuxc_libdir}/libfontconfig.a


%changelog
