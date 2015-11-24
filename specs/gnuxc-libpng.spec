%?gnuxc_package_header

Name:           gnuxc-libpng
Version:        1.6.19
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        zlib
Group:          System Environment/Libraries
URL:            http://www.libpng.org/pub/png/libpng.html
Source0:        http://prdownloads.sourceforge.net/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.xz

Patch001:       http://prdownloads.sourceforge.net/libpng-apng/%{gnuxc_name}-%{version}-apng.patch.gz

BuildRequires:  gnuxc-zlib-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-zlib-devel

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
%patch001 -p1

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --with-binconfigs
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/libpng16-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-libpng16-config
ln -fs %{gnuxc_target}-libpng16-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-libpng-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/{pngfix,png-fix-itxt}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpng{,16}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpng16.so.16
%{gnuxc_libdir}/libpng16.so.16.19.0
%doc ANNOUNCE CHANGES INSTALL README TODO
%license LICENSE

%files devel
%{_bindir}/%{gnuxc_target}-libpng-config
%{_bindir}/%{gnuxc_target}-libpng16-config
%{gnuxc_root}/bin/libpng-config
%{gnuxc_root}/bin/libpng16-config
%{gnuxc_includedir}/libpng16
%{gnuxc_includedir}/png.h
%{gnuxc_includedir}/pngconf.h
%{gnuxc_includedir}/pnglibconf.h
%{gnuxc_libdir}/libpng.so
%{gnuxc_libdir}/libpng16.so
%{gnuxc_libdir}/pkgconfig/libpng.pc
%{gnuxc_libdir}/pkgconfig/libpng16.pc

%files static
%{gnuxc_libdir}/libpng.a
%{gnuxc_libdir}/libpng16.a


%changelog
