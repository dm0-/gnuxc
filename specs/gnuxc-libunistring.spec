%?gnuxc_package_header

Name:           gnuxc-libunistring
Version:        0.9.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+
Group:          System Environment/Libraries
URL:            http://www.gnu.org/software/libunistring/
Source0:        http://ftp.gnu.org/gnu/libunistring/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

BuildArch:      noarch

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
    --enable-relocatable \
    --enable-threads=posix
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libunistring.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_infodir}


%files
%{gnuxc_libdir}/libunistring.so.0
%{gnuxc_libdir}/libunistring.so.0.1.2
%doc AUTHORS BUGS ChangeLog COPYING* DEPENDENCIES HACKING NEWS README THANKS

%files devel
%{gnuxc_includedir}/unicase.h
%{gnuxc_includedir}/uniconv.h
%{gnuxc_includedir}/unictype.h
%{gnuxc_includedir}/unilbrk.h
%{gnuxc_includedir}/uniname.h
%{gnuxc_includedir}/uninorm.h
%{gnuxc_includedir}/unistdio.h
%{gnuxc_includedir}/unistr.h
%{gnuxc_includedir}/unistring
%{gnuxc_includedir}/unitypes.h
%{gnuxc_includedir}/uniwbrk.h
%{gnuxc_includedir}/uniwidth.h
%{gnuxc_libdir}/libunistring.so

%files static
%{gnuxc_libdir}/libunistring.a


%changelog
