%?gnuxc_package_header

Name:           gnuxc-flex
Version:        2.6.4
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://github.com/westes/flex
Source0:        http://github.com/westes/flex/releases/download/v%{version}/%{gnuxc_name}-%{version}.tar.lz

BuildRequires:  gnuxc-glibc-devel

BuildRequires:  lzip
BuildRequires:  m4

Requires:       gnuxc-gcc-c++

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Provides:       %{name}-static = %{version}-%{release}
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Skip tests.
sed -i -e '/^SUBDIRS *=/,/^$/{/tests/d;}' Makefile.in

%build
%gnuxc_configure \
    --disable-nls \
    \
    --disable-rpath \
    --enable-libfl \
    --enable-warnings
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{flex,flex++}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libfl{,_pic}.la

# Skip the documentation.
rm -rf \
    %{buildroot}%{gnuxc_docdir} \
    %{buildroot}%{gnuxc_infodir} \
    %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libfl.so.2
%{gnuxc_libdir}/libfl.so.2.0.0
%doc AUTHORS ChangeLog NEWS ONEWS README.md THANKS
%license COPYING

%files devel
%{gnuxc_includedir}/FlexLexer.h
%{gnuxc_libdir}/libfl.a
%{gnuxc_libdir}/libfl.so
