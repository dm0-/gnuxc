%?gnuxc_package_header

Name:           gnuxc-p11-kit
Version:        0.23.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://p11-glue.freedesktop.org/p11-kit.html
Source0:        http://p11-glue.freedesktop.org/releases/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-libffi-devel
BuildRequires:  gnuxc-libtasn1-devel
BuildRequires:  gnuxc-pkg-config

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-doc \
    --disable-nls \
    \
    --disable-rpath \
    --enable-debug=default \
    --enable-trust-module \
    --with-hash-impl=internal \
    --with-libffi \
    --with-libtasn1 \
    \
    --disable-static \
    --disable-strict
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{p11-kit,trust}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/{libp11-kit,pkcs11/p11-kit-trust}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc


%files
%{gnuxc_datadir}/p11-kit
%{gnuxc_libdir}/libp11-kit.so.0
%{gnuxc_libdir}/libp11-kit.so.0.1.0
%{gnuxc_libdir}/p11-kit
%{gnuxc_libdir}/p11-kit-proxy.so
%{gnuxc_libdir}/pkcs11
%{gnuxc_sysconfdir}/pkcs11
%doc AUTHORS ChangeLog HACKING NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/p11-kit-1
%{gnuxc_libdir}/libp11-kit.so
%{gnuxc_libdir}/pkgconfig/p11-kit-1.pc
