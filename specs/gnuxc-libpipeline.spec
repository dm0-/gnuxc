%?gnuxc_package_header

Name:           gnuxc-libpipeline
Version:        1.5.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
URL:            http://libpipeline.nongnu.org/
Source0:        http://download.savannah.gnu.org/releases/libpipeline/%{gnuxc_name}-%{version}.tar.gz

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
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-rpath \
    --enable-socketpair-pipe \
    --enable-static \
    --enable-threads=posix
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpipeline.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpipeline.so.1
%{gnuxc_libdir}/libpipeline.so.%{version}
%doc ChangeLog NEWS README TODO
%license COPYING

%files devel
%{gnuxc_includedir}/pipeline.h
%{gnuxc_libdir}/libpipeline.so
%{gnuxc_libdir}/pkgconfig/libpipeline.pc

%files static
%{gnuxc_libdir}/libpipeline.a
