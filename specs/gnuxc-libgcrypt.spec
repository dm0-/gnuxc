%?gnuxc_package_header

Name:           gnuxc-libgcrypt
Version:        1.8.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://gnupg.org/software/libgcrypt/
Source0:        ftp://ftp.gnupg.org/gcrypt/libgcrypt/%{gnuxc_name}-%{version}.tar.bz2

Patch101:       %{gnuxc_name}-%{version}-build-fixes.patch

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
%autosetup -n %{gnuxc_name}-%{version} -p0

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --enable-dev-random \
    --enable-hmac-binary-check \
    --enable-m-guard \
    --enable-static \
    GPG_ERROR_CONFIG=%{_bindir}/%{gnuxc_target}-gpg-error-config \
    \
    --disable-asm \
    --disable-random-daemon \
    --without-capabilities
%gnuxc_make_build all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 0755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/libgcrypt-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-libgcrypt-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/{dumpsexp,hmac256,mpicalc}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libgcrypt.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libgcrypt.so.20
%{gnuxc_libdir}/libgcrypt.so.20.2.2
%doc AUTHORS ChangeLog* NEWS README* THANKS TODO
%license COPYING COPYING.LIB LICENSES

%files devel
%{_bindir}/%{gnuxc_target}-libgcrypt-config
%{gnuxc_root}/bin/libgcrypt-config
%{gnuxc_includedir}/gcrypt.h
%{gnuxc_libdir}/libgcrypt.so

%files static
%{gnuxc_libdir}/libgcrypt.a
