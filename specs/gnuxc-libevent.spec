%?gnuxc_package_header

Name:           gnuxc-libevent
Version:        2.0.21
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
Group:          System Environment/Libraries
URL:            http://libevent.org/
Source0:        http://prdownloads.sourceforge.net/levent/%{gnuxc_name}-%{version}-stable.tar.gz

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
%setup -q -n %{gnuxc_name}-%{version}-stable

%build
%gnuxc_configure \
    --enable-debug-mode \
    --enable-function-sections \
    --enable-gcc-warnings \
    --enable-thread-support
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libevent{,_core,_extra,_pthreads}.la

# This functionality should be used from the system package.
rm -f %{buildroot}%{gnuxc_bindir}/event_rpcgen.py

%files
%{gnuxc_libdir}/libevent-2.0.so.5
%{gnuxc_libdir}/libevent-2.0.so.5.1.9
%{gnuxc_libdir}/libevent_core-2.0.so.5
%{gnuxc_libdir}/libevent_core-2.0.so.5.1.9
%{gnuxc_libdir}/libevent_extra-2.0.so.5
%{gnuxc_libdir}/libevent_extra-2.0.so.5.1.9
%{gnuxc_libdir}/libevent_pthreads-2.0.so.5
%{gnuxc_libdir}/libevent_pthreads-2.0.so.5.1.9
%doc ChangeLog LICENSE README

%files devel
%{gnuxc_includedir}/evdns.h
%{gnuxc_includedir}/event.h
%{gnuxc_includedir}/event2
%{gnuxc_includedir}/evhttp.h
%{gnuxc_includedir}/evrpc.h
%{gnuxc_includedir}/evutil.h
%{gnuxc_libdir}/libevent.so
%{gnuxc_libdir}/libevent_core.so
%{gnuxc_libdir}/libevent_extra.so
%{gnuxc_libdir}/libevent_pthreads.so
%{gnuxc_libdir}/pkgconfig/libevent.pc
%{gnuxc_libdir}/pkgconfig/libevent_pthreads.pc

%files static
%{gnuxc_libdir}/libevent.a
%{gnuxc_libdir}/libevent_core.a
%{gnuxc_libdir}/libevent_extra.a
%{gnuxc_libdir}/libevent_pthreads.a


%changelog
