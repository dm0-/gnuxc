%?gnuxc_package_header

Name:           gnuxc-libksba
Version:        1.3.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        (LGPLv3+ or GPLv2+) and GPLv3+
URL:            http://gnupg.org/software/libksba/
Source0:        ftp://ftp.gnupg.org/gcrypt/libksba/%{gnuxc_name}-%{version}.tar.bz2

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
    --enable-static \
    GPG_ERROR_CONFIG=/usr/bin/%{gnuxc_host}-gpg-error-config
%gnuxc_make_build all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 0755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/ksba-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-ksba-config

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libksba.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir}


%files
%{gnuxc_libdir}/libksba.so.8
%{gnuxc_libdir}/libksba.so.8.11.6
%doc AUTHORS ChangeLog* NEWS README THANKS TODO
%license COPYING COPYING.GPLv2 COPYING.GPLv3 COPYING.LGPLv3

%files devel
%{_bindir}/%{gnuxc_target}-ksba-config
%{gnuxc_root}/bin/ksba-config
%{gnuxc_includedir}/ksba.h
%{gnuxc_libdir}/libksba.so

%files static
%{gnuxc_libdir}/libksba.a
