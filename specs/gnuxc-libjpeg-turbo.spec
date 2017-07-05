%?gnuxc_package_header

Name:           gnuxc-libjpeg-turbo
Version:        1.5.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        IJG
URL:            http://libjpeg-turbo.virtualgl.org/
Source0:        http://prdownloads.sourceforge.net/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

BuildRequires:  libtool
BuildRequires:  nasm

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
%setup -q -n %{gnuxc_name}-%{version}
chmod -c 644 *.md

%build
%gnuxc_configure \
    --disable-silent-rules \
    --with-arith-{enc,dec} \
    --with-simd \
    --with-turbojpeg \
    \
    --without-java
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install \
    docdir=%{gnuxc_docdir}/%{gnuxc_name} \
    exampledir=%{gnuxc_docdir}/%{gnuxc_name}

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{{c,d}jpeg,jpegtran,{rd,wr}jpgcom,tjbench}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/lib{,turbo}jpeg.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libjpeg.so.62
%{gnuxc_libdir}/libjpeg.so.62.2.0
%{gnuxc_libdir}/libturbojpeg.so.0
%{gnuxc_libdir}/libturbojpeg.so.0.1.0
%doc ChangeLog.md README.ijg README.md
%license LICENSE.md

%files devel
%{gnuxc_includedir}/jconfig.h
%{gnuxc_includedir}/jerror.h
%{gnuxc_includedir}/jmorecfg.h
%{gnuxc_includedir}/jpeglib.h
%{gnuxc_includedir}/turbojpeg.h
%{gnuxc_libdir}/libjpeg.so
%{gnuxc_libdir}/libturbojpeg.so
%{gnuxc_libdir}/pkgconfig/libjpeg.pc
%{gnuxc_libdir}/pkgconfig/libturbojpeg.pc

%files static
%{gnuxc_libdir}/libjpeg.a
%{gnuxc_libdir}/libturbojpeg.a
