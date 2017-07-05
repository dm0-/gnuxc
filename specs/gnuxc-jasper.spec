%?gnuxc_package_header

Name:           gnuxc-jasper
Version:        1.900.31
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        JasPer
URL:            http://www.ece.uvic.ca/~frodo/jasper/
Source0:        http://github.com/mdadams/%{gnuxc_name}/archive/version-%{version}.tar.gz

BuildRequires:  gnuxc-libjpeg-turbo-devel

BuildRequires:  libtool

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libjpeg-turbo-devel

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
%setup -q -n %{gnuxc_name}-version-%{version}
autoreconf -fi

%build
%gnuxc_configure \
    --enable-debug \
    --enable-libjpeg \
    --with-x \
    EXTRACFLAGS="$CFLAGS" \
    \
    --disable-opengl # This requires libGLUT.
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{imgcmp,imginfo,jasper,tmrdemo}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libjasper.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libjasper.so.4
%{gnuxc_libdir}/libjasper.so.4.0.0
%doc ChangeLog doc/*.pdf NEWS README
%license LICENSE

%files devel
%{gnuxc_includedir}/jasper
%{gnuxc_libdir}/libjasper.so
%{gnuxc_libdir}/pkgconfig/jasper.pc

%files static
%{gnuxc_libdir}/libjasper.a
