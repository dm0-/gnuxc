%?gnuxc_package_header

Name:           gnuxc-pcre2
Version:        10.30
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://www.pcre.org/
Source0:        ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-bzip2-devel
BuildRequires:  gnuxc-readline-devel
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
    --bindir=%{gnuxc_root}/bin \
    \
    --enable-pcre2-{8,16,32} \
    --enable-jit \
    --enable-unicode \
    --enable-newline-is-any \
    --enable-pcre2grep-libz \
    --enable-pcre2grep-libbz2 \
    --enable-pcre2test-libreadline \
    \
    --enable-debug
%gnuxc_make_build all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 0755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/pcre2-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-pcre2-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/pcre2{grep,test}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpcre2-{8,16,32,posix}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}/%{gnuxc_name} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpcre2-8.so.0
%{gnuxc_libdir}/libpcre2-8.so.0.6.0
%{gnuxc_libdir}/libpcre2-16.so.0
%{gnuxc_libdir}/libpcre2-16.so.0.6.0
%{gnuxc_libdir}/libpcre2-32.so.0
%{gnuxc_libdir}/libpcre2-32.so.0.6.0
%{gnuxc_libdir}/libpcre2-posix.so.2
%{gnuxc_libdir}/libpcre2-posix.so.2.0.0
%doc AUTHORS ChangeLog HACKING NEWS README
%license COPYING LICENCE

%files devel
%{_bindir}/%{gnuxc_target}-pcre2-config
%{gnuxc_root}/bin/pcre2-config
%{gnuxc_includedir}/pcre2.h
%{gnuxc_includedir}/pcre2posix.h
%{gnuxc_libdir}/libpcre2-8.so
%{gnuxc_libdir}/libpcre2-16.so
%{gnuxc_libdir}/libpcre2-32.so
%{gnuxc_libdir}/libpcre2-posix.so
%{gnuxc_libdir}/pkgconfig/libpcre2-8.pc
%{gnuxc_libdir}/pkgconfig/libpcre2-16.pc
%{gnuxc_libdir}/pkgconfig/libpcre2-32.pc
%{gnuxc_libdir}/pkgconfig/libpcre2-posix.pc

%files static
%{gnuxc_libdir}/libpcre2-8.a
%{gnuxc_libdir}/libpcre2-16.a
%{gnuxc_libdir}/libpcre2-32.a
%{gnuxc_libdir}/libpcre2-posix.a
