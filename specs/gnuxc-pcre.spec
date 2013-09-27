%?gnuxc_package_header

Name:           gnuxc-pcre
Version:        8.33
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
Group:          System Environment/Libraries
URL:            http://www.pcre.org/
Source0:        ftp://ftp.csx.cam.ac.uk/pub/software/programming/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-bzip2-devel
BuildRequires:  gnuxc-readline-devel
BuildRequires:  gnuxc-zlib-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

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

# Seriously disable rpaths.
sed -i -e 's/\(need_relink\)=yes/\1=no/' ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' configure

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --disable-silent-rules \
    --enable-pcre16 \
    --enable-pcre32 \
    --enable-jit \
    --enable-unicode-properties \
    --enable-newline-is-any \
    --enable-pcregrep-libz \
    --enable-pcregrep-libbz2 \
    --enable-pcretest-libreadline
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/pcre-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-pcre-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/pcre{grep,test}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libpcre{,16,32,cpp,posix}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir}/%{gnuxc_name} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpcre.so.1
%{gnuxc_libdir}/libpcre.so.1.2.1
%{gnuxc_libdir}/libpcre16.so.0
%{gnuxc_libdir}/libpcre16.so.0.2.1
%{gnuxc_libdir}/libpcre32.so.0
%{gnuxc_libdir}/libpcre32.so.0.0.1
%{gnuxc_libdir}/libpcrecpp.so.0
%{gnuxc_libdir}/libpcrecpp.so.0.0.0
%{gnuxc_libdir}/libpcreposix.so.0
%{gnuxc_libdir}/libpcreposix.so.0.0.2
%doc AUTHORS ChangeLog COPYING LICENCE NEWS README

%files devel
%{_bindir}/%{gnuxc_target}-pcre-config
%{gnuxc_root}/bin/pcre-config
%{gnuxc_includedir}/pcre.h
%{gnuxc_includedir}/pcre_scanner.h
%{gnuxc_includedir}/pcre_stringpiece.h
%{gnuxc_includedir}/pcrecpp.h
%{gnuxc_includedir}/pcrecpparg.h
%{gnuxc_includedir}/pcreposix.h
%{gnuxc_libdir}/libpcre.so
%{gnuxc_libdir}/libpcre16.so
%{gnuxc_libdir}/libpcre32.so
%{gnuxc_libdir}/libpcrecpp.so
%{gnuxc_libdir}/libpcreposix.so
%{gnuxc_libdir}/pkgconfig/libpcre.pc
%{gnuxc_libdir}/pkgconfig/libpcre16.pc
%{gnuxc_libdir}/pkgconfig/libpcre32.pc
%{gnuxc_libdir}/pkgconfig/libpcrecpp.pc
%{gnuxc_libdir}/pkgconfig/libpcreposix.pc

%files static
%{gnuxc_libdir}/libpcre.a
%{gnuxc_libdir}/libpcre16.a
%{gnuxc_libdir}/libpcre32.a
%{gnuxc_libdir}/libpcrecpp.a
%{gnuxc_libdir}/libpcreposix.a


%changelog
