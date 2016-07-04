%?gnuxc_package_header

Name:           gnuxc-osl
Version:        0.9.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://icps.u-strasbg.fr/people/bastoul/public_html/development/openscop/
Source0:        http://icps.u-strasbg.fr/people/bastoul/public_html/development/openscop/docs/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-gmp-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gmp-devel

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
    --disable-silent-rules \
    --enable-portable-binary \
    --with-gcc-arch=%{gnuxc_arch} \
    --with-gmp=system
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libosl.la


%files
%{gnuxc_libdir}/libosl.so.0
%{gnuxc_libdir}/libosl.so.0.0.0
%doc doc/openscop.pdf AUTHORS ChangeLog NEWS README THANKS
%license COPYING

%files devel
%{gnuxc_includedir}/osl
%{gnuxc_libdir}/libosl.so

%files static
%{gnuxc_libdir}/libosl.a
