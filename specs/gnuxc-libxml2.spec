%?gnuxc_package_header

Name:           gnuxc-libxml2
Version:        2.9.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          Development/Libraries
URL:            http://xmlsoft.org/
Source0:        ftp://xmlsoft.org/libxml2/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-readline-devel
BuildRequires:  gnuxc-xz-devel
BuildRequires:  gnuxc-zlib-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

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
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --disable-silent-rules \
    --with-fexceptions \
    --with-history \
    --with-mem-debug \
    --with-run-debug \
    --with-thread-alloc \
    \
    --without-icu \
    --without-python
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/xml2-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-xml2-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/xml{catalog,lint}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libxml2.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}{%{gnuxc_datadir}/gtk-doc,%{gnuxc_docdir},%{gnuxc_mandir}}


%files
%{gnuxc_libdir}/libxml2.so.2
%{gnuxc_libdir}/libxml2.so.2.9.1
%doc AUTHORS ChangeLog COPYING Copyright NEWS README* TODO*

%files devel
%{_bindir}/%{gnuxc_target}-xml2-config
%{gnuxc_root}/bin/xml2-config
%{gnuxc_includedir}/libxml2
%{gnuxc_libdir}/libxml2.so
%{gnuxc_libdir}/pkgconfig/libxml-2.0.pc
%{gnuxc_libdir}/xml2Conf.sh

%files static
%{gnuxc_libdir}/libxml2.a


%changelog
