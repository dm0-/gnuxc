%?gnuxc_package_header

Name:           gnuxc-libcroco
Version:        0.6.8
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2.1
Group:          System Environment/Libraries
URL:            http://developer.gnome.org/libcroco/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/0.6/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-libxml2-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glib-devel
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

sed -i -e 's/@\(GLIB\|LIBXML\)2_\(CFLAG\|LIB\)S@//g' croco-config.in

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --disable-silent-rules \
    --enable-checks
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/croco-0.6-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-croco-0.6-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/csslint-0.6

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libcroco-0.6.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc


%files
%{gnuxc_libdir}/libcroco-0.6.so.3
%{gnuxc_libdir}/libcroco-0.6.so.3.0.1
%doc AUTHORS ChangeLog COPYING* HACKING NEWS README TODO

%files devel
%{_bindir}/%{gnuxc_target}-croco-0.6-config
%{gnuxc_root}/bin/croco-0.6-config
%{gnuxc_includedir}/libcroco-0.6
%{gnuxc_libdir}/libcroco-0.6.so
%{gnuxc_libdir}/pkgconfig/libcroco-0.6.pc

%files static
%{gnuxc_libdir}/libcroco-0.6.a


%changelog
