%?gnuxc_package_header

Name:           gnuxc-speexdsp
Version:        1.2
%global snap    rc3
Release:        0.%{snap}.1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.speex.org/
Source0:        http://downloads.xiph.org/releases/speex/%{gnuxc_name}-%{version}%{snap}.tar.gz

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
%setup -q -n %{gnuxc_name}-%{version}%{snap}

%build
%gnuxc_configure \
    --disable-examples \
    --disable-silent-rules \
    --enable-sse \
    --with-fft=smallft
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libspeexdsp.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}


%files
%{gnuxc_libdir}/libspeexdsp.so.1
%{gnuxc_libdir}/libspeexdsp.so.1.5.0
%doc AUTHORS ChangeLog NEWS README TODO
%license COPYING

%files devel
%{gnuxc_includedir}/speex
%{gnuxc_libdir}/libspeexdsp.so
%{gnuxc_libdir}/pkgconfig/speexdsp.pc

%files static
%{gnuxc_libdir}/libspeexdsp.a
