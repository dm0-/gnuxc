%?gnuxc_package_header

Name:           gnuxc-npth
Version:        1.5
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://gnupg.org/software/npth/
Source0:        ftp://ftp.gnupg.org/gcrypt/npth/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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
ln %{buildroot}%{gnuxc_root}/bin/npth-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-npth-config

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libnpth.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal


%files
%{gnuxc_libdir}/libnpth.so.0
%{gnuxc_libdir}/libnpth.so.0.1.1
%doc AUTHORS ChangeLog HACKING NEWS README
%license COPYING.LIB

%files devel
%{_bindir}/%{gnuxc_target}-npth-config
%{gnuxc_root}/bin/npth-config
%{gnuxc_includedir}/npth.h
%{gnuxc_libdir}/libnpth.so

%files static
%{gnuxc_libdir}/libnpth.a
