%?gnuxc_package_header

Name:           gnuxc-libpipeline
Version:        1.4.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
Group:          Development/Libraries
URL:            http://libpipeline.nongnu.org/
Source0:        http://download.savannah.gnu.org/releases/libpipeline/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

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

%build
%gnuxc_configure \
    --disable-rpath \
    --disable-silent-rules \
    --enable-socketpair-pipe \
    --enable-static \
    --enable-threads=posix
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpipeline.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpipeline.so.1
%{gnuxc_libdir}/libpipeline.so.%{version}
%doc ChangeLog COPYING NEWS README TODO

%files devel
%{gnuxc_includedir}/pipeline.h
%{gnuxc_libdir}/libpipeline.so
%{gnuxc_libdir}/pkgconfig/libpipeline.pc

%files static
%{gnuxc_libdir}/libpipeline.a


%changelog
