%?gnuxc_package_header

Name:           gnuxc-libxml2
Version:        2.9.4
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://xmlsoft.org/
Source0:        ftp://xmlsoft.org/libxml2/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-icu4c-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-python-devel
BuildRequires:  gnuxc-readline-devel
BuildRequires:  gnuxc-xz-devel
BuildRequires:  gnuxc-zlib-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-icu4c-devel

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

# Use pkg-config for python configuration.
sed -i configure \
    -e '/PYTHON_INCLUDES=`/s,`.*`,`%{gnuxc_pkgconfig} --cflags python3`,' \
    -e '/PYTHON_LIBS=`/s,`.*`,`%{gnuxc_pkgconfig} --libs python3`,' \
    -e '/PYTHON_SITE_PACKAGES=`/s,`.*`,%{gnuxc_libdir}/python`%{gnuxc_pkgconfig} --modversion python3`/site-packages,' \
    -e '/PYTHON_VERSION=`/s,`.*`,`%{gnuxc_pkgconfig} --modversion python3`,'
sed -i -e 's/-I..PYTHON_INCLUDES./$(PYTHON_INCLUDES)/' python/Makefile.in

# Use the correct icu-config script.
sed -i -e '/^ *ICU_CONFIG=/s/=.*/=%{gnuxc_target}-icu-config/' configure

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --disable-silent-rules \
    --with-fexceptions \
    --with-history \
    --with-icu \
    --with-lzma \
    --with-python PYTHON=/usr/bin/python3 \
    --with-readline \
    --with-thread-alloc \
    --with-zlib \
    \
    --with-mem-debug \
    --with-run-debug
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
pyver=$(env -i %{gnuxc_pkgconfig} --modversion python3)
rm -rf \
    %{buildroot}%{gnuxc_datadir}/aclocal \
    %{buildroot}%{gnuxc_libdir}/python$pyver

# Remove cmake files for now.
rm -f %{buildroot}%{gnuxc_libdir}/cmake/libxml2/libxml2-config.cmake

# Skip the documentation.
rm -rf %{buildroot}{%{gnuxc_datadir}/gtk-doc,%{gnuxc_docdir},%{gnuxc_mandir}}


%files
%{gnuxc_libdir}/libxml2.so.2
%{gnuxc_libdir}/libxml2.so.%{version}
%doc AUTHORS ChangeLog NEWS README README.tests TODO TODO_SCHEMAS
%license Copyright

%files devel
%{_bindir}/%{gnuxc_target}-xml2-config
%{gnuxc_root}/bin/xml2-config
%{gnuxc_includedir}/libxml2
%{gnuxc_libdir}/libxml2.so
%{gnuxc_libdir}/pkgconfig/libxml-2.0.pc
%{gnuxc_libdir}/xml2Conf.sh

%files static
%{gnuxc_libdir}/libxml2.a
