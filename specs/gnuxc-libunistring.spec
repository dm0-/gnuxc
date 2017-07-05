%?gnuxc_package_header

Name:           gnuxc-libunistring
Version:        0.9.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+
URL:            http://www.gnu.org/software/libunistring/
Source0:        http://ftpmirror.gnu.org/libunistring/%{gnuxc_name}-%{version}.tar.xz

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
%setup -q -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-rpath \
    --enable-threads=posix \
    PACKAGE_TARNAME=libunistring \
    \
    --disable-relocatable # This results in undefined symbols when linking.
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libunistring.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_infodir}


%files
%{gnuxc_libdir}/libunistring.so.2
%{gnuxc_libdir}/libunistring.so.2.0.0
%doc AUTHORS BUGS ChangeLog HACKING NEWS README THANKS
%license COPYING COPYING.LIB

%files devel
%{gnuxc_includedir}/unicase.h
%{gnuxc_includedir}/uniconv.h
%{gnuxc_includedir}/unictype.h
%{gnuxc_includedir}/unigbrk.h
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
