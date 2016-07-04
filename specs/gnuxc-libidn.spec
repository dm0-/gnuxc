%?gnuxc_package_header

Name:           gnuxc-libidn
Version:        1.32
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+ and GPLv3+ and GFDL
URL:            http://www.gnu.org/software/libidn/
Source0:        http://ftpmirror.gnu.org/libidn/%{gnuxc_name}-%{version}.tar.gz

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

# Work around bad prerequisites (due to anti-rpath scripts).
sed -i -e '/gdoc:.*configure/s, [^ ]*/configure , ,' doc/Makefile.in

%build
%gnuxc_env ; CFLAGS=${CFLAGS/-Werror=format-security /}
%gnuxc_configure \
    --disable-nls \
    \
    --disable-rpath \
    --disable-silent-rules \
    --enable-gcc-warnings gl_cv_warn_c__Werror=no \
    --enable-threads=posix
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/idn

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libidn.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/emacs

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libidn.so.11
%{gnuxc_libdir}/libidn.so.11.6.15
%doc AUTHORS ChangeLog FAQ HACKING NEWS README THANKS TODO
%license COPYING COPYING.LESSERv2 COPYING.LESSERv3 COPYINGv2 COPYINGv3

%files devel
%{gnuxc_includedir}/idn-free.h
%{gnuxc_includedir}/idn-int.h
%{gnuxc_includedir}/idna.h
%{gnuxc_includedir}/pr29.h
%{gnuxc_includedir}/punycode.h
%{gnuxc_includedir}/stringprep.h
%{gnuxc_includedir}/tld.h
%{gnuxc_libdir}/libidn.so
%{gnuxc_libdir}/pkgconfig/libidn.pc

%files static
%{gnuxc_libdir}/libidn.a
