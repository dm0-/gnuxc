%global gnuxc_has_env %(rpm --quiet -q gnuxc-libihash && echo 1 || echo 0)

# (This value is used in the RPM release number in order to ensure the full
# packages are always an upgrade over bootstrapping sub-packages.)

%?gnuxc_package_header

%global __filter_GLIBC_PRIVATE 1

Name:           gnuxc-libpthread
Version:        0.3
%global snap    b9eb71
Release:        1.%{gnuxc_has_env}.19700101git%{snap}%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+ and LGPLv2.1+ and LGPLv3+
Group:          System Environment/Libraries
URL:            http://www.gnu.org/software/hurd/
Source0:        %{gnuxc_name}-%{version}-%{snap}.tar.xz

# Ship customizations in the SRPM, but they are already applied in the archive.
Patch101:       %{gnuxc_name}-%{version}-%{snap}-new-files.patch
Patch102:       %{gnuxc_name}-%{version}-%{snap}-fix-new-automake.patch

BuildRequires:  gnuxc-gcc
%if 0%{gnuxc_has_env}
BuildRequires:  gnuxc-libihash-devel
%endif

BuildArch:      noarch

%description
%{summary}.

%package headers
Summary:        POSIX thread system headers from GNU Hurd for cross-compiling
Requires:       gnuxc-filesystem

%description headers
This package provides system headers taken from the GNU Hurd's POSIX thread
library for use with cross-compilers.

%if 0%{gnuxc_has_env}
%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       %{name}-headers = %{version}-%{release}
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
%endif


%prep
%setup -q -n %{gnuxc_name}-%{version}-%{snap}

%build
%if 0%{gnuxc_has_env}
%gnuxc_configure
%gnuxc_make %{?_smp_mflags} all
%else
%gnuxc_configure \
    CC='%{gnuxc_cc} -nostdlib' \
    ac_cv_lib_ihash_hurd_ihash_create=yes
%endif

%install
%if 0%{gnuxc_has_env}
%gnuxc_make_install
rm -f %{buildroot}%{gnuxc_libdir}/libpthread.la
%else
%gnuxc_make install-data-local-headers DESTDIR=%{buildroot}
%endif


%files headers
%{gnuxc_includedir}/bits
%{gnuxc_includedir}/pthread
%{gnuxc_includedir}/pthread.h
%{gnuxc_includedir}/semaphore.h
%doc AUTHORS COPYING ChangeLog NEWS README TODO

%if 0%{gnuxc_has_env}
%files
%{gnuxc_libdir}/libpthread.so.0
%{gnuxc_libdir}/libpthread.so.0.0.0
%{gnuxc_libdir}/libpthread.so.0.3
%files devel
%{gnuxc_libdir}/libpthread.so
%files static
%{gnuxc_libdir}/libpthread.a
%{gnuxc_libdir}/libpthread2.a
%endif


%changelog
