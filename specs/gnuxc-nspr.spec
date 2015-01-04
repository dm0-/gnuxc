%?gnuxc_package_header

Name:           gnuxc-nspr
Version:        4.10.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MPLv2.0
Group:          System Environment/Libraries
URL:            http://www.mozilla.org/projects/nspr/
Source0:        http://ftp.mozilla.org/pub/nspr/releases/v%{version}/src/%{gnuxc_name}-%{version}.tar.gz

Patch001:       http://hg.mozilla.org/projects/nspr/raw-rev/1fcea1618bb7#/%{gnuxc_name}-%{version}-posix-fix.patch
Patch101:       %{gnuxc_name}-%{version}-hurd-port.patch

BuildRequires:  gnuxc-gcc-c++

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gcc-c++

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
mv %{gnuxc_name}/{*,.[^.]*} .
%patch001 -p1
%patch101

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --disable-strip \
    --enable-cplus \
    --enable-debug --enable-debug-symbols \
    --enable-ipv6 \
    --enable-optimize \
    --with-pthreads
%__make -C config %{?_smp_mflags} export CC=gcc
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/nspr-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-nspr-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/{compile-et.pl,prerr.properties}

# This functionality should be used from the system package.
rm -f %{buildroot}%{gnuxc_datadir}/aclocal/nspr.m4


%files
%{gnuxc_libdir}/libnspr4.so
%{gnuxc_libdir}/libplc4.so
%{gnuxc_libdir}/libplds4.so
%doc LICENSE

%files devel
%{_bindir}/%{gnuxc_target}-nspr-config
%{gnuxc_root}/bin/nspr-config
%{gnuxc_includedir}/nspr
%{gnuxc_libdir}/pkgconfig/nspr.pc

%files static
%{gnuxc_libdir}/libnspr4.a
%{gnuxc_libdir}/libplc4.a
%{gnuxc_libdir}/libplds4.a


%changelog
