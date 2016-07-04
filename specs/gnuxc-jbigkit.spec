%?gnuxc_package_header

Name:           gnuxc-jbigkit
Version:        2.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv2+
URL:            http://www.cl.cam.ac.uk/~mgk25/jbigkit/
Source0:        http://www.cl.cam.ac.uk/~mgk25/download/%{gnuxc_name}-%{version}.tar.gz

Patch101:       %{gnuxc_name}-%{version}-environment.patch
Patch102:       %{gnuxc_name}-%{version}-shlib.patch

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
%patch101
%patch102

%build
%gnuxc_env
%gnuxc_make %{?_smp_mflags} lib \
    AR='%{gnuxc_ar}' \
    RANLIB='%{gnuxc_ranlib}'

%install
install -Dpm 755 libjbig/libjbig.so.%{version} \
    %{buildroot}%{gnuxc_libdir}/libjbig.so.%{version}
ln -s libjbig.so.%{version} %{buildroot}%{gnuxc_libdir}/libjbig.so
install -Dpm 755 libjbig/libjbig85.so.%{version} \
    %{buildroot}%{gnuxc_libdir}/libjbig85.so.%{version}
ln -s libjbig85.so.%{version} %{buildroot}%{gnuxc_libdir}/libjbig85.so

install -Dpm 644 libjbig/libjbig.a   %{buildroot}%{gnuxc_libdir}/libjbig.a
install -Dpm 644 libjbig/libjbig85.a %{buildroot}%{gnuxc_libdir}/libjbig85.a

install -Dpm 644 libjbig/jbig.h    %{buildroot}%{gnuxc_includedir}/jbig.h
install -Dpm 644 libjbig/jbig85.h  %{buildroot}%{gnuxc_includedir}/jbig85.h
install -Dpm 644 libjbig/jbig_ar.h %{buildroot}%{gnuxc_includedir}/jbig_ar.h


%files
%{gnuxc_libdir}/libjbig.so.%{version}
%{gnuxc_libdir}/libjbig85.so.%{version}
%doc ANNOUNCE CHANGES INSTALL libjbig/jbig*.txt TODO
%license COPYING

%files devel
%{gnuxc_includedir}/jbig.h
%{gnuxc_includedir}/jbig85.h
%{gnuxc_includedir}/jbig_ar.h
%{gnuxc_libdir}/libjbig.so
%{gnuxc_libdir}/libjbig85.so

%files static
%{gnuxc_libdir}/libjbig.a
%{gnuxc_libdir}/libjbig85.a
