%?gnuxc_package_header

Name:           gnuxc-mpc
Version:        1.0.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+ and GFDL
Group:          System Environment/Libraries
URL:            http://www.gnu.org/software/mpc/
Source0:        http://ftpmirror.gnu.org/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-mpfr-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-mpfr-devel

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
%gnuxc_configure
%gnuxc_make %{?_smp_mflags} all

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


%changelog
