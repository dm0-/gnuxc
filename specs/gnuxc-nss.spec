%?gnuxc_package_header

Name:           gnuxc-nss
Version:        3.21
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MPLv2.0
Group:          System Environment/Libraries
URL:            http://www.mozilla.org/projects/security/pki/nss/
Source0:        http://ftp.mozilla.org/pub/security/nss/releases/NSS_%(echo %{version} | sed 's/\./_/g')_RTM/src/%{gnuxc_name}-%{version}.tar.gz

Patch101:       %{gnuxc_name}-%{version}-hurd-port.patch

BuildRequires:  gnuxc-nspr-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-sqlite-devel
BuildRequires:  gnuxc-zlib-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-nspr-devel

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
mv %{gnuxc_name}/{*,.[!.]*} .
chmod -c 644 *.txt
%patch101

%build
%global nss_configuration \\\
    ARCHFLAG= \\\
    BUILD_OPT=1 \\\
    BUILD_TREE="$PWD" \\\
    CC='%{gnuxc_cc}' \\\
    MOZ_DEBUG_SYMBOLS=1 \\\
    NSPR_INCLUDE_DIR="`%{gnuxc_pkgconfig} --cflags-only-I nspr | sed s/^-I//`" \\\
    NSS_DISABLE_DBM=1 \\\
    NSS_DISABLE_GTESTS=1 \\\
    NSS_USE_SYSTEM_SQLITE=1 \\\
    OBJDIR_NAME=gnu \\\
    USE_PTHREADS=1 \\\
    USE_SYSTEM_ZLIB=1
sed --in-place nss.pc nss-config \
    -e "s/@NSS_MAJOR_VERSION@/`echo %{version} | cut -d. -f1`/g" \
    -e "s/@NSS_MINOR_VERSION@/`echo %{version} | cut -d. -f2`/g" \
    -e "s/@NSS_PATCH_VERSION@/`echo %{version} | cut -d. -f3`/g" \
    -e 's/@PKG_CONFIG@/%{gnuxc_pkgconfig}/g' \
    -e 's,@prefix@,%{gnuxc_prefix},g'
%gnuxc_env
%__make -C coreconf/nsinstall -j1 libs %{nss_configuration} CC=gcc
%__make -C lib/freebl -j1 export %{nss_configuration}
%__make -C lib/util -j1 export %{nss_configuration}
%__make -C cmd/shlibsign -j1 libs %{nss_configuration} CC=gcc DIRS= \
    NSS_BUILD_WITHOUT_SOFTOKEN=1
%gnuxc_make -j1 all %{nss_configuration}

%install
install -dm 755 %{buildroot}%{gnuxc_includedir}/nss
install -pm 644 -t %{buildroot}%{gnuxc_includedir}/nss dist/public/nss/*

install -dm 755 %{buildroot}%{gnuxc_libdir}
install -pm 755 -t %{buildroot}%{gnuxc_libdir} dist/gnu/lib/*.so
install -pm 644 -t %{buildroot}%{gnuxc_libdir} dist/gnu/lib/*.{a,chk}

install -Dpm 755 nss-config %{buildroot}%{gnuxc_root}/bin/nss-config
install -Dpm 644 nss.pc %{buildroot}%{gnuxc_libdir}/pkgconfig/nss.pc

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/nss-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-nss-config


%files
%{gnuxc_libdir}/libfreebl3.chk
%{gnuxc_libdir}/libfreebl3.so
%{gnuxc_libdir}/libnss3.so
%{gnuxc_libdir}/libnssckbi.so
%{gnuxc_libdir}/libnsssysinit.so
%{gnuxc_libdir}/libnssutil3.so
%{gnuxc_libdir}/libsmime3.so
%{gnuxc_libdir}/libsoftokn3.chk
%{gnuxc_libdir}/libsoftokn3.so
%{gnuxc_libdir}/libssl3.so
%license COPYING trademarks.txt

%files devel
%{_bindir}/%{gnuxc_target}-nss-config
%{gnuxc_root}/bin/nss-config
%{gnuxc_includedir}/nss
%{gnuxc_libdir}/libcrmf.a
%{gnuxc_libdir}/pkgconfig/nss.pc

%files static
%{gnuxc_libdir}/libcertdb.a
%{gnuxc_libdir}/libcerthi.a
%{gnuxc_libdir}/libcryptohi.a
%{gnuxc_libdir}/libfreebl.a
%{gnuxc_libdir}/libjar.a
%{gnuxc_libdir}/libnss.a
%{gnuxc_libdir}/libnssb.a
%{gnuxc_libdir}/libnssckfw.a
%{gnuxc_libdir}/libnssdev.a
%{gnuxc_libdir}/libnsspki.a
%{gnuxc_libdir}/libnsssysinit.a
%{gnuxc_libdir}/libnssutil.a
%{gnuxc_libdir}/libpk11wrap.a
%{gnuxc_libdir}/libpkcs12.a
%{gnuxc_libdir}/libpkcs7.a
%{gnuxc_libdir}/libpkixcertsel.a
%{gnuxc_libdir}/libpkixchecker.a
%{gnuxc_libdir}/libpkixcrlsel.a
%{gnuxc_libdir}/libpkixmodule.a
%{gnuxc_libdir}/libpkixparams.a
%{gnuxc_libdir}/libpkixpki.a
%{gnuxc_libdir}/libpkixresults.a
%{gnuxc_libdir}/libpkixstore.a
%{gnuxc_libdir}/libpkixsystem.a
%{gnuxc_libdir}/libpkixtop.a
%{gnuxc_libdir}/libpkixutil.a
%{gnuxc_libdir}/libsectool.a
%{gnuxc_libdir}/libsmime.a
%{gnuxc_libdir}/libsoftokn.a
%{gnuxc_libdir}/libssl.a


%changelog
