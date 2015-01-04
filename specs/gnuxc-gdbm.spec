%?gnuxc_package_header

Name:           gnuxc-gdbm
Version:        1.11
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
Group:          System Environment/Libraries
URL:            http://www.gnu.org/software/gdbm/
Source0:        http://ftpmirror.gnu.org/gdbm/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

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
    --disable-nls \
    \
    --disable-rpath \
    --disable-silent-rules
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/gdbm{_dump,_load,tool}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libgdbm.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libgdbm.so.4
%{gnuxc_libdir}/libgdbm.so.4.0.0
%doc AUTHORS ChangeLog COPYING NEWS NOTE-WARNING README THANKS

%files devel
%{gnuxc_includedir}/gdbm.h
%{gnuxc_libdir}/libgdbm.so

%files static
%{gnuxc_libdir}/libgdbm.a


%changelog
