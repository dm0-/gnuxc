%?gnuxc_package_header

Name:           gnuxc-libevent
Version:        2.1.8
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        BSD
URL:            http://libevent.org/
Source0:        http://github.com/libevent/libevent/releases/download/release-%{version}-stable/%{gnuxc_name}-%{version}-stable.tar.gz

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
%setup -q -n %{gnuxc_name}-%{version}-stable

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-clock-gettime \
    --enable-debug-mode \
    --enable-function-sections \
    --enable-thread-support \
    \
    --disable-gcc-warnings
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libevent{,_core,_extra,_pthreads}.la

# This functionality should be used from the system package.
rm -f %{buildroot}%{gnuxc_bindir}/event_rpcgen.py

%files
%{gnuxc_libdir}/libevent-2.1.so.6
%{gnuxc_libdir}/libevent-2.1.so.6.0.2
%{gnuxc_libdir}/libevent_core-2.1.so.6
%{gnuxc_libdir}/libevent_core-2.1.so.6.0.2
%{gnuxc_libdir}/libevent_extra-2.1.so.6
%{gnuxc_libdir}/libevent_extra-2.1.so.6.0.2
%{gnuxc_libdir}/libevent_pthreads-2.1.so.6
%{gnuxc_libdir}/libevent_pthreads-2.1.so.6.0.2
%doc ChangeLog*
%license LICENSE

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
%{gnuxc_libdir}/pkgconfig/libevent_core.pc
%{gnuxc_libdir}/pkgconfig/libevent_extra.pc
%{gnuxc_libdir}/pkgconfig/libevent_pthreads.pc

%files static
%{gnuxc_libdir}/libevent.a
%{gnuxc_libdir}/libevent_core.a
%{gnuxc_libdir}/libevent_extra.a
%{gnuxc_libdir}/libevent_pthreads.a
