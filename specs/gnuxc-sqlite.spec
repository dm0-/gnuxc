%?gnuxc_package_header

Name:           gnuxc-sqlite
Version:        3.13.0
%global realver 3130000
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        Public Domain
URL:            http://www.sqlite.org/
Source0:        http://www.sqlite.org/2016/%{gnuxc_name}-autoconf-%{realver}.tar.gz

BuildRequires:  gnuxc-ncurses-devel
BuildRequires:  gnuxc-readline-devel

BuildRequires:  libtool

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
%setup -q -n %{gnuxc_name}-autoconf-%{realver}

%build
%gnuxc_configure \
    --disable-editline \
    --disable-static-shell \
    --enable-dynamic-extensions \
    --enable-fts5 \
    --enable-json1 \
    --enable-readline \
    --enable-threadsafe \
    CPPFLAGS='-DSQLITE_ENABLE_UNLOCK_NOTIFY -DSQLITE_SECURE_DELETE' \
    ac_cv_search_tgetent=-ltinfow
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/sqlite3

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libsqlite3.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libsqlite3.so.0
%{gnuxc_libdir}/libsqlite3.so.0.8.6
%doc README.txt

%files devel
%{gnuxc_includedir}/sqlite3.h
%{gnuxc_includedir}/sqlite3ext.h
%{gnuxc_libdir}/libsqlite3.so
%{gnuxc_libdir}/pkgconfig/sqlite3.pc

%files static
%{gnuxc_libdir}/libsqlite3.a
