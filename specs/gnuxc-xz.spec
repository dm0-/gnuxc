%?gnuxc_package_header

Name:           gnuxc-xz
Version:        5.2.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        Public Domain and GPLv2+
URL:            http://tukaani.org/xz/
Source0:        http://tukaani.org/xz/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glibc-devel

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
    --disable-lzma-links \
    --disable-lzmadec \
    --disable-lzmainfo \
    --disable-nls \
    --disable-scripts \
    --disable-xz \
    --disable-xzdec \
    \
    --disable-rpath \
    --enable-debug \
    --enable-symbol-versions
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/liblzma.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}


%files
%{gnuxc_libdir}/liblzma.so.5
%{gnuxc_libdir}/liblzma.so.%{version}
%doc AUTHORS ChangeLog NEWS README THANKS TODO
%license COPYING COPYING.GPLv2 COPYING.GPLv3 COPYING.LGPLv2.1

%files devel
%{gnuxc_includedir}/lzma
%{gnuxc_includedir}/lzma.h
%{gnuxc_libdir}/liblzma.so
%{gnuxc_libdir}/pkgconfig/liblzma.pc

%files static
%{gnuxc_libdir}/liblzma.a
