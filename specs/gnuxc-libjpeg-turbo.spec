%?gnuxc_package_header

Name:           gnuxc-libjpeg-turbo
Version:        1.3.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        IJG
Group:          System Environment/Libraries
URL:            http://libjpeg-turbo.virtualgl.org/
Source0:        http://prdownloads.sourceforge.net/libjpeg-turbo/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

BuildRequires:  nasm

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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

# Rewrite the old configure script.
autoreconf -fi

%build
%gnuxc_configure \
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
%{gnuxc_libdir}/libjpeg.so.62.1.0
%{gnuxc_libdir}/libturbojpeg.so.0
%{gnuxc_libdir}/libturbojpeg.so.0.0.0
%doc BUILDING.txt README*

%files devel
%{gnuxc_includedir}/jconfig.h
%{gnuxc_includedir}/jerror.h
%{gnuxc_includedir}/jmorecfg.h
%{gnuxc_includedir}/jpeglib.h
%{gnuxc_includedir}/turbojpeg.h
%{gnuxc_libdir}/libjpeg.so
%{gnuxc_libdir}/libturbojpeg.so

%files static
%{gnuxc_libdir}/libjpeg.a
%{gnuxc_libdir}/libturbojpeg.a


%changelog
