%?gnuxc_package_header

Name:           gnuxc-gdbm
Version:        1.12
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
URL:            http://www.gnu.org/software/gdbm/
Source0:        http://ftpmirror.gnu.org/gdbm/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

BuildRequires:  texinfo

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
    --disable-nls \
    \
    --disable-rpath \
    --disable-silent-rules \
    --enable-libgdbm-compat
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/gdbm{_dump,_load,tool}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libgdbm{,_compat}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libgdbm.so.4
%{gnuxc_libdir}/libgdbm.so.4.0.0
%{gnuxc_libdir}/libgdbm_compat.so.4
%{gnuxc_libdir}/libgdbm_compat.so.4.0.0
%doc AUTHORS ChangeLog NEWS NOTE-WARNING README THANKS
%license COPYING

%files devel
%{gnuxc_includedir}/dbm.h
%{gnuxc_includedir}/gdbm.h
%{gnuxc_includedir}/ndbm.h
%{gnuxc_libdir}/libgdbm.so
%{gnuxc_libdir}/libgdbm_compat.so

%files static
%{gnuxc_libdir}/libgdbm.a
%{gnuxc_libdir}/libgdbm_compat.a
