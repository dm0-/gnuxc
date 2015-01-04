# Declare that this package does not require a complete GCC.
%global gnuxc_bootstrapped 0

%?gnuxc_package_header

%global __filter_GLIBC_PRIVATE 1
%global __provides_exclude_from ^%{gnuxc_libdir}/gconv/
%global __requires_exclude_from ^%{gnuxc_libdir}/gconv/

Name:           gnuxc-glibc
Version:        2.17.90
%global snap    7a3271
Release:        1.19700101git%{snap}%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

%global lpname  libpthread
%global lpvers  0.3
%global lpsnap  ed9f86

License:        LGPLv2+ and LGPLv2+ with exceptions and GPLv2+
Group:          System Environment/Libraries
URL:            http://www.gnu.org/software/glibc/
Source0:        http://git.savannah.gnu.org/cgit/hurd/%{gnuxc_name}.git/snapshot/%{gnuxc_name}-%{snap}.tar.xz
Source1:        http://git.savannah.gnu.org/cgit/hurd/%{lpname}.git/snapshot/%{lpname}-%{lpsnap}.tar.xz

Patch101:       %{gnuxc_name}-%{version}-%{snap}-provide-hurd-api.patch
Patch102:       %{gnuxc_name}-%{version}-%{snap}-create-gnumach-header.patch
Patch201:       %{gnuxc_name}-%{version}-%{snap}-%{lpname}-%{lpvers}-%{lpsnap}-steal-libihash.patch
Patch202:       %{gnuxc_name}-%{version}-%{snap}-%{lpname}-%{lpvers}-%{lpsnap}-glibc-preparation.patch

Requires:       gnuxc-filesystem

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-hurd-headers
BuildRequires:  gnuxc-mig

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gcc
Requires:       gnuxc-hurd-headers

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
%setup -q -n %{gnuxc_name}-%{snap}
%patch101
%patch102
sed -i -e '/ | 3/s/)/ | 4.*)/' -e 's/nss-config /%{gnuxc_target}-&/' configure
sed -i -e '59a@end deftypefun' manual/platform.texi

%setup -q -D -T -a 1 -n %{gnuxc_name}-%{snap}
mv %{lpname}-%{lpsnap} %{lpname} && cd %{lpname}
%patch201
%patch202

# Work around an earlier gnuxc-libpthread-headers requirement.
mkdir -p include_hack/bits && cd include_hack/bits
ln -s ../../sysdeps/{i386/bits/spin-lock,generic/bits/}*.h .

%build
%global _configure ../configure
%global gnuxc_env \
    CFLAGS='-O3 -g -pipe -Wall -fasynchronous-unwind-tables ' ; \
    CFLAGS+="--param=ssp-buffer-size=4 -march=%{gnuxc_arch} -mtune=generic" ; \
    export CFLAGS
mkdir -p build && pushd build
%gnuxc_configure \
    --disable-multi-arch \
    --enable-all-warnings \
    --enable-obsolete-rpc \
    --enable-stackguard-randomization \
    BASH_SHELL=/bin/bash \
    \
    -disable-nscd
popd
%gnuxc_make -C build %{?_smp_mflags} all \
    CC="%{gnuxc_gcc} -I$PWD/%{lpname}/include_hack" \
    install_root=.
# This target seems to break parallel builds when given in the above command.
%gnuxc_make -C build %{?_smp_mflags} info

%install
# These dirs are needed because ld scripts are dumb when it comes to sysroots.
%gnuxc_make_install -C build \
    {lib,rtld,slib}dir=%{_prefix}/lib \
    inst_{lib,rtld,slib}dir=%{buildroot}%{gnuxc_libdir} \
    auditdir=%{gnuxc_libdir}/audit \
    gconvdir=%{gnuxc_libdir}/gconv

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/{catchsegv,gencat,getconf,getent,iconv,ldd} \
    %{buildroot}%{gnuxc_bindir}/{locale{,def},makedb,mtrace,pcprofiledump} \
    %{buildroot}%{gnuxc_bindir}/{pldd,rpcgen,sotruss,sprof,tzselect,xtrace} \
    %{buildroot}%{gnuxc_sbindir}/{iconvconfig,sln,zdump,zic}

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir}

# Provide a default ld.so link.
ln -s ld.so.1 %{buildroot}%{gnuxc_libdir}/ld.so

%find_lang libc
while read -r l file ; do rm -f %{buildroot}$file ; done < libc.lang


%files
%{gnuxc_datadir}/i18n
%{gnuxc_datadir}/locale/locale.alias
%{gnuxc_libdir}/audit
%{gnuxc_libdir}/gconv
%{gnuxc_libdir}/libmemusage.so
%{gnuxc_libdir}/libpcprofile.so
%{gnuxc_libdir}/libSegFault.so
%{gnuxc_libdir}/ld.so.1
%{gnuxc_libdir}/ld-%{version}.so
%{gnuxc_libdir}/libanl.so.1
%{gnuxc_libdir}/libanl-%{version}.so
%{gnuxc_libdir}/libBrokenLocale.so.1
%{gnuxc_libdir}/libBrokenLocale-%{version}.so
%{gnuxc_libdir}/libc.so.0.3
%{gnuxc_libdir}/libc-%{version}.so
%{gnuxc_libdir}/libcidn.so.1
%{gnuxc_libdir}/libcidn-%{version}.so
%{gnuxc_libdir}/libcrypt.so.1
%{gnuxc_libdir}/libcrypt-%{version}.so
%{gnuxc_libdir}/libdl.so.2
%{gnuxc_libdir}/libdl-%{version}.so
%{gnuxc_libdir}/libhurduser.so.0.3
%{gnuxc_libdir}/libhurduser-%{version}.so
%{gnuxc_libdir}/libm.so.6
%{gnuxc_libdir}/libm-%{version}.so
%{gnuxc_libdir}/libmachuser.so.1
%{gnuxc_libdir}/libmachuser-%{version}.so
%{gnuxc_libdir}/libnsl.so.1
%{gnuxc_libdir}/libnsl-%{version}.so
%{gnuxc_libdir}/libnss_compat.so.2
%{gnuxc_libdir}/libnss_compat-%{version}.so
%{gnuxc_libdir}/libnss_db.so.2
%{gnuxc_libdir}/libnss_db-%{version}.so
%{gnuxc_libdir}/libnss_dns.so.2
%{gnuxc_libdir}/libnss_dns-%{version}.so
%{gnuxc_libdir}/libnss_files.so.2
%{gnuxc_libdir}/libnss_files-%{version}.so
%{gnuxc_libdir}/libnss_hesiod.so.2
%{gnuxc_libdir}/libnss_hesiod-%{version}.so
%{gnuxc_libdir}/libnss_nis.so.2
%{gnuxc_libdir}/libnss_nis-%{version}.so
%{gnuxc_libdir}/libnss_nisplus.so.2
%{gnuxc_libdir}/libnss_nisplus-%{version}.so
%{gnuxc_libdir}/libpthread.so.0.3
%{gnuxc_libdir}/libpthread-%{version}.so
%{gnuxc_libdir}/libresolv.so.2
%{gnuxc_libdir}/libresolv-%{version}.so
%{gnuxc_libdir}/librt.so.1
%{gnuxc_libdir}/librt-%{version}.so
%{gnuxc_libdir}/libutil.so.1
%{gnuxc_libdir}/libutil-%{version}.so
%{gnuxc_libexecdir}/getconf
%{gnuxc_libexecdir}/pt_chown
%{gnuxc_localstatedir}/db/Makefile
%{gnuxc_sysconfdir}/rpc
%doc BUGS ChangeLog* CONFORMANCE COPYING* LICENSES NEWS PROJECTS README

%files devel
%{gnuxc_includedir}/arpa
%{gnuxc_includedir}/bits
%{gnuxc_includedir}/device/device.h
%{gnuxc_includedir}/device/device_request.h
%{gnuxc_includedir}/gnu
%{gnuxc_includedir}/hurd/auth.h
%{gnuxc_includedir}/hurd/crash.h
%{gnuxc_includedir}/hurd/exec.h
%{gnuxc_includedir}/hurd/exec_startup.h
%{gnuxc_includedir}/hurd/fd.h
%{gnuxc_includedir}/hurd/fs.h
%{gnuxc_includedir}/hurd/fsys.h
%{gnuxc_includedir}/hurd/id.h
%{gnuxc_includedir}/hurd/ifsock.h
%{gnuxc_includedir}/hurd/interrupt.h
%{gnuxc_includedir}/hurd/io.h
%{gnuxc_includedir}/hurd/io_reply.h
%{gnuxc_includedir}/hurd/io_request.h
%{gnuxc_includedir}/hurd/ioctl.h
%{gnuxc_includedir}/hurd/login.h
%{gnuxc_includedir}/hurd/lookup.h
%{gnuxc_includedir}/hurd/msg.h
%{gnuxc_includedir}/hurd/msg_reply.h
%{gnuxc_includedir}/hurd/msg_request.h
%{gnuxc_includedir}/hurd/msg_server.h
%{gnuxc_includedir}/hurd/password.h
%{gnuxc_includedir}/hurd/pfinet.h
%{gnuxc_includedir}/hurd/port.h
%{gnuxc_includedir}/hurd/process.h
%{gnuxc_includedir}/hurd/process_request.h
%{gnuxc_includedir}/hurd/resource.h
%{gnuxc_includedir}/hurd/signal.h
%{gnuxc_includedir}/hurd/sigpreempt.h
%{gnuxc_includedir}/hurd/socket.h
%{gnuxc_includedir}/hurd/startup.h
%{gnuxc_includedir}/hurd/term.h
%{gnuxc_includedir}/hurd/threadvar.h
%{gnuxc_includedir}/hurd/tioctl.h
%{gnuxc_includedir}/hurd/userlink.h
%{gnuxc_includedir}/mach/default_pager.h
%{gnuxc_includedir}/mach/error.h
%{gnuxc_includedir}/mach/exc.h
%{gnuxc_includedir}/mach/exc_server.h
%{gnuxc_includedir}/mach/gnumach.h
%{gnuxc_includedir}/mach/i386/mach_i386.h
%{gnuxc_includedir}/mach/mach.h
%{gnuxc_includedir}/mach/mach4.h
%{gnuxc_includedir}/mach/mach_host.h
%{gnuxc_includedir}/mach/mach_interface.h
%{gnuxc_includedir}/mach/mach_port.h
%{gnuxc_includedir}/mach/mach_traps.h
%{gnuxc_includedir}/mach/memory_object_default.h
%{gnuxc_includedir}/mach/memory_object_user.h
%{gnuxc_includedir}/mach/mig_support.h
%{gnuxc_includedir}/net
%{gnuxc_includedir}/netinet
%{gnuxc_includedir}/nfs
%{gnuxc_includedir}/protocols
%{gnuxc_includedir}/pthread
%{gnuxc_includedir}/rpc
%{gnuxc_includedir}/rpcsvc
%{gnuxc_includedir}/sys/*.h
%{gnuxc_includedir}/*.h
%{gnuxc_libdir}/crt[01in].o
%{gnuxc_libdir}/gcrt[01].o
%{gnuxc_libdir}/[MS]crt1.o
%{gnuxc_libdir}/ld.so
%{gnuxc_libdir}/libanl.so
%{gnuxc_libdir}/libBrokenLocale.so
%{gnuxc_libdir}/libbsd-compat.a
%{gnuxc_libdir}/libc.so
%{gnuxc_libdir}/libcidn.so
%{gnuxc_libdir}/libcrt.a
%{gnuxc_libdir}/libcrt_nonshared.a
%{gnuxc_libdir}/libcrypt.so
%{gnuxc_libdir}/libdl.so
%{gnuxc_libdir}/libg.a
%{gnuxc_libdir}/libhurduser.so
%{gnuxc_libdir}/libieee.a
%{gnuxc_libdir}/libm.so
%{gnuxc_libdir}/libmachuser.so
%{gnuxc_libdir}/libmcheck.a
%{gnuxc_libdir}/libnsl.so
%{gnuxc_libdir}/libnss_compat.so
%{gnuxc_libdir}/libnss_db.so
%{gnuxc_libdir}/libnss_dns.so
%{gnuxc_libdir}/libnss_files.so
%{gnuxc_libdir}/libnss_hesiod.so
%{gnuxc_libdir}/libnss_nis.so
%{gnuxc_libdir}/libnss_nisplus.so
%{gnuxc_libdir}/libpthread.so
%{gnuxc_libdir}/libresolv.so
%{gnuxc_libdir}/librpcsvc.a
%{gnuxc_libdir}/librt.so
%{gnuxc_libdir}/libutil.so

%files static
%{gnuxc_libdir}/libanl.a
%{gnuxc_libdir}/libBrokenLocale.a
%{gnuxc_libdir}/libc.a
%{gnuxc_libdir}/libcrypt.a
%{gnuxc_libdir}/libdl.a
%{gnuxc_libdir}/libhurduser.a
%{gnuxc_libdir}/libm.a
%{gnuxc_libdir}/libmachuser.a
%{gnuxc_libdir}/libnsl.a
%{gnuxc_libdir}/libpthread.a
%{gnuxc_libdir}/libpthread2.a
%{gnuxc_libdir}/libresolv.a
%{gnuxc_libdir}/librt.a
%{gnuxc_libdir}/libutil.a


%changelog
