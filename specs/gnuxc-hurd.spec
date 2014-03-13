%global gnuxc_has_env %(
(rpm --quiet -q gnuxc-parted && echo 1) || # Change to 2 if packaging Hurd
(rpm --quiet -q gnuxc-glibc  && echo 1) || echo 0)

# (This value is used in the RPM release number in order to ensure the full
# packages are always an upgrade over bootstrapping sub-packages.)

%?gnuxc_package_header

Name:           gnuxc-hurd
Version:        0.5
%global snap    cc9757
Release:        1.%{gnuxc_has_env}.19700101git%{snap}%{?dist}
Summary:        GNU Hurd kernel

License:        GPLv2+ and LGPLv2+ and GPLv3+ and LGPLv3+
Group:          System Environment/Kernel
URL:            http://www.gnu.org/software/hurd/
Source0:        %{gnuxc_name}-%{version}-%{snap}.tar.xz

# Ship customizations in the SRPM, but they are already applied in the archive.
Patch101:       %{gnuxc_name}-%{version}-%{snap}-allow-user-installs.patch
Patch102:       %{gnuxc_name}-%{version}-%{snap}-console-nocaps.patch
Patch103:       %{gnuxc_name}-%{version}-%{snap}-disable-services.patch

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-gnumach-headers
BuildRequires:  gnuxc-mig
%if 0%{gnuxc_has_env} >= 1
BuildRequires:  gnuxc-bzip2-devel
BuildRequires:  gnuxc-zlib-devel
%endif
%if 0%{gnuxc_has_env} >= 2
BuildRequires:  gnuxc-bzip2-static
BuildRequires:  gnuxc-glibc-static
BuildRequires:  gnuxc-libblkid-devel
BuildRequires:  gnuxc-libuuid-static
BuildRequires:  gnuxc-parted-static
BuildRequires:  gnuxc-zlib-static
%endif

BuildArch:      noarch

%description
This source package holds the GNU Hurd kernel, but (at the moment) only a few
subpackages are built from it to provide system libraries for cross-compiling.

%package headers
Summary:        System headers from GNU Hurd used for cross-compiling
Group:          Development/System
Requires:       gnuxc-gnumach-headers

%description headers
This package provides system headers taken from the GNU Hurd kernel source for
use with cross-compilers.

%if 0%{gnuxc_has_env} >= 1
%package libs
Summary:        Cross-compiled versions of Hurd libraries for the GNU system
Group:          System Environment/Libraries

%description libs
Cross-compiled versions of Hurd libraries for the GNU system.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name}-libs = %{version}-%{release}
Requires:       %{name}-headers = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications or translators that use Hurd libraries on GNU systems.

%package static
Summary:        Static libraries of %{name}
Group:          Development/Libraries
Requires:       %{name}-devel = %{version}-%{release}

%description static
The %{name}-static package contains the static Hurd libraries for -static
linking on GNU systems.  You don't need these, unless you link statically,
which is highly discouraged.
%endif


%prep
%setup -q -n %{gnuxc_name}-%{version}-%{snap}

%build
%gnuxc_configure \
%if 0%{gnuxc_has_env} < 2
%if 0%{gnuxc_has_env} == 0
    CC='%{gnuxc_cc} -nostdlib' \
%endif
    --without-libdaemon \
    --without-parted
%endif

%if 0%{gnuxc_has_env} >= 1
%gnuxc_make %{?_smp_mflags} \
    lib{fshelp,ihash,iohelp,netfs,ports,ps,shouldbeinlibc,store}
%endif

%install
%gnuxc_make install-headers \
    includedir=%{buildroot}%{gnuxc_includedir} \
    no_deps=t

%if 0%{gnuxc_has_env} >= 1
%gnuxc_make \
    lib{fshelp,ihash,iohelp,netfs,ports,ps,shouldbeinlibc,store}-install \
    includedir=%{buildroot}%{gnuxc_includedir} \
    libdir=%{buildroot}%{gnuxc_libdir}

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 755 %{buildroot}%{gnuxc_libdir}/lib*.so.*.*
%endif


%files headers
%{gnuxc_includedir}/hurd
%{gnuxc_includedir}/sys/procfs.h
%{gnuxc_includedir}/*.h
%doc BUGS ChangeLog COPYING INSTALL* NEWS README* tasks TODO

%if 0%{gnuxc_has_env} >= 1
%files libs
%{gnuxc_libdir}/libfshelp.so.0.3
%{gnuxc_libdir}/libihash.so.0.3
%{gnuxc_libdir}/libiohelp.so.0.3
%{gnuxc_libdir}/libnetfs.so.0.3
%{gnuxc_libdir}/libports.so.0.3
%{gnuxc_libdir}/libps.so.0.3
%{gnuxc_libdir}/libshouldbeinlibc.so.0.3
%{gnuxc_libdir}/libstore.so.0.3

%files devel
%{gnuxc_libdir}/libfshelp.so
%{gnuxc_libdir}/libihash.so
%{gnuxc_libdir}/libiohelp.so
%{gnuxc_libdir}/libnetfs.so
%{gnuxc_libdir}/libports.so
%{gnuxc_libdir}/libps.so
%{gnuxc_libdir}/libshouldbeinlibc.so
%{gnuxc_libdir}/libstore.so

%files static
%{gnuxc_libdir}/libfshelp.a
%{gnuxc_libdir}/libfshelp_p.a
%{gnuxc_libdir}/libfshelp_pic.a
%{gnuxc_libdir}/libihash.a
%{gnuxc_libdir}/libihash_p.a
%{gnuxc_libdir}/libihash_pic.a
%{gnuxc_libdir}/libiohelp.a
%{gnuxc_libdir}/libiohelp_p.a
%{gnuxc_libdir}/libiohelp_pic.a
%{gnuxc_libdir}/libnetfs.a
%{gnuxc_libdir}/libnetfs_p.a
%{gnuxc_libdir}/libnetfs_pic.a
%{gnuxc_libdir}/libports.a
%{gnuxc_libdir}/libports_p.a
%{gnuxc_libdir}/libports_pic.a
%{gnuxc_libdir}/libps.a
%{gnuxc_libdir}/libps_p.a
%{gnuxc_libdir}/libps_pic.a
%{gnuxc_libdir}/libshouldbeinlibc.a
%{gnuxc_libdir}/libshouldbeinlibc_p.a
%{gnuxc_libdir}/libshouldbeinlibc_pic.a
%{gnuxc_libdir}/libstore.a
%{gnuxc_libdir}/libstore_p.a
%{gnuxc_libdir}/libstore_pic.a
%{gnuxc_libdir}/libstore_bunzip2.a
%{gnuxc_libdir}/libstore_concat.a
%{gnuxc_libdir}/libstore_copy.a
%{gnuxc_libdir}/libstore_device.a
%{gnuxc_libdir}/libstore_file.a
%{gnuxc_libdir}/libstore_gunzip.a
%{gnuxc_libdir}/libstore_ileave.a
%{gnuxc_libdir}/libstore_memobj.a
%{gnuxc_libdir}/libstore_module.a
%{gnuxc_libdir}/libstore_mvol.a
%{gnuxc_libdir}/libstore_nbd.a
%{gnuxc_libdir}/libstore_remap.a
%{gnuxc_libdir}/libstore_task.a
%{gnuxc_libdir}/libstore_zero.a
%endif


%changelog
