%?gnuxc_package_header

Name:           gnuxc-font-util
Version:        1.3.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          User Interface/X
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/font/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel

Requires:       gnuxc-libX11

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-strict-compilation \
    --with-fontrootdir='${datadir}/X11/fonts'
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{bdftruncate,ucs2any}

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_datadir}/X11/fonts/util
%doc ChangeLog COPYING README

%files devel
%{gnuxc_libdir}/pkgconfig/fontutil.pc


%changelog
