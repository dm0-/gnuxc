%?gnuxc_package_header

Name:           gnuxc-flex
Version:        2.6.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://flex.sourceforge.net/
Source0:        http://prdownloads.sourceforge.net/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glibc-devel

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
    --disable-rpath
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
%{gnuxc_libdir}/libfl_pic.so.2
%{gnuxc_libdir}/libfl_pic.so.2.0.0
%doc AUTHORS ChangeLog NEWS ONEWS README THANKS TODO
%license COPYING

%files devel
%{gnuxc_includedir}/FlexLexer.h
%{gnuxc_libdir}/libfl.a
%{gnuxc_libdir}/libfl.so
%{gnuxc_libdir}/libfl_pic.a
%{gnuxc_libdir}/libfl_pic.so
