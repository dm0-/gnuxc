%?gnuxc_package_header

Name:           gnuxc-flex
Version:        2.5.38
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
Group:          Development/Tools
URL:            http://flex.sourceforge.net/
Source0:        http://prdownloads.sourceforge.net/flex/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel

Requires:       gnuxc-gcc-c++

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Provides:       %{name}-static = %{version}-%{release}
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%setup -q -n %{gnuxc_name}-%{version}

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
%doc AUTHORS ChangeLog COPYING NEWS ONEWS README THANKS TODO

%files devel
%{gnuxc_includedir}/FlexLexer.h
%{gnuxc_libdir}/libfl.a
%{gnuxc_libdir}/libfl.so
%{gnuxc_libdir}/libfl_pic.a
%{gnuxc_libdir}/libfl_pic.so


%changelog
