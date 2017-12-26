%?gnuxc_package_header

Name:           gnuxc-libidn2
Version:        2.0.4
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+ and GPLv3+ and GFDL
URL:            http://www.gnu.org/software/libidn/
Source0:        http://ftpmirror.gnu.org/libidn/%{gnuxc_name}-%{version}.tar.lz

BuildRequires:  gnuxc-libunistring-devel

BuildRequires:  lzip

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
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    --disable-doc \
    --disable-rpath \
    --enable-gcc-warnings gl_cv_warn_c__Werror=no
%gnuxc_make_build all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/idn2

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libidn2.la

# Skip the documentation.
rm -rf \
    %{buildroot}%{gnuxc_datadir}/gtk-doc \
    %{buildroot}%{gnuxc_infodir} \
    %{buildroot}%{gnuxc_mandir}

%files
%{gnuxc_libdir}/libidn2.so.0
%{gnuxc_libdir}/libidn2.so.0.3.3
%doc AUTHORS ChangeLog CONTRIBUTING.md NEWS README.md
%license COPYING COPYING.LESSERv3 COPYING.unicode COPYINGv2

%files devel
%{gnuxc_includedir}/idn2.h
%{gnuxc_libdir}/libidn2.so
%{gnuxc_libdir}/pkgconfig/libidn2.pc

%files static
%{gnuxc_libdir}/libidn2.a
