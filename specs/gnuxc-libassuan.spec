%?gnuxc_package_header

Name:           gnuxc-libassuan
Version:        2.5.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+ and GPLv3+
URL:            http://gnupg.org/software/libassuan/
Source0:        ftp://ftp.gnupg.org/gcrypt/libassuan/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libgpg-error-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libgpg-error-devel

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
    --bindir=%{gnuxc_root}/bin \
    \
    --enable-static
%gnuxc_make_build all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 0755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/libassuan-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-libassuan-config

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libassuan.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir}


%files
%{gnuxc_libdir}/libassuan.so.0
%{gnuxc_libdir}/libassuan.so.0.8.1
%doc AUTHORS ChangeLog* NEWS README THANKS TODO
%license COPYING COPYING.LIB

%files devel
%{_bindir}/%{gnuxc_target}-libassuan-config
%{gnuxc_root}/bin/libassuan-config
%{gnuxc_includedir}/assuan.h
%{gnuxc_libdir}/libassuan.so

%files static
%{gnuxc_libdir}/libassuan.a
