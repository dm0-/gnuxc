%?gnuxc_package_header

Name:           gnuxc-mpc
Version:        1.0.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+ and GFDL
URL:            http://www.gnu.org/software/mpc/
Source0:        http://ftpmirror.gnu.org/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.gz

Patch001:       https://scm.gforge.inria.fr/anonscm/gitweb?p=mpc/mpc.git;a=commitdiff_plain;h=36a84f43f326de14db888ba07936cc9621c23f19#/%{gnuxc_name}-%{version}-update-mpfr-1.patch
Patch002:       https://scm.gforge.inria.fr/anonscm/gitweb?p=mpc/mpc.git;a=commitdiff_plain;h=5eaa17651b759c7856a118835802fecbebcf46ad#/%{gnuxc_name}-%{version}-update-mpfr-2.patch

BuildRequires:  gnuxc-mpfr-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-mpfr-devel

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

# Backport patches for MPFR 4 support.
sed \
    -e '/8,6/,/endif/{s/8,6/8,7/;s/.*MPFR_MANT.*/ /;s/.*#endif/-\n&/;}' \
    -e 's/macros/macroes/;s/MPFR_RNDN/GMP_RNDN/' \
    %{patches} | patch -F2 -p1
autoreconf -fi

%build
%gnuxc_configure
%gnuxc_make_build all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libmpc.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir}


%files
%{gnuxc_libdir}/libmpc.so.3
%{gnuxc_libdir}/libmpc.so.3.0.0
%doc AUTHORS ChangeLog NEWS README TODO
%license COPYING.LESSER

%files devel
%{gnuxc_includedir}/mpc.h
%{gnuxc_libdir}/libmpc.so

%files static
%{gnuxc_libdir}/libmpc.a
