%?gnuxc_package_header

Name:           gnuxc-file
Version:        5.32
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.darwinsys.com/file/
Source0:        ftp://ftp.astron.com/pub/file/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-zlib-devel

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
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --enable-elf \
    --enable-elf-core \
    --enable-fsect-man5 \
    --enable-static \
    --enable-warnings
%gnuxc_make_build -C src magic.h
%gnuxc_make_build -C src libmagic.la

%install
%gnuxc_make -C src install-{nodist_includeHEADERS,libLTLIBRARIES} \
    DESTDIR=%{buildroot}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libmagic.la


%files
%{gnuxc_libdir}/libmagic.so.1
%{gnuxc_libdir}/libmagic.so.1.0.0
%doc AUTHORS ChangeLog MAINT NEWS README TODO
%license COPYING

%files devel
%{gnuxc_includedir}/magic.h
%{gnuxc_libdir}/libmagic.so

%files static
%{gnuxc_libdir}/libmagic.a
