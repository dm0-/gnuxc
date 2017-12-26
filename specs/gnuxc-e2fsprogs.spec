%?gnuxc_package_header

Name:           gnuxc-e2fsprogs
Version:        1.43.7
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv2 and LGPLv2 and BSD and MIT
URL:            http://e2fsprogs.sourceforge.net/
Source0:        http://prdownloads.sourceforge.net/%{gnuxc_name}/%{gnuxc_name}-libs-%{version}.tar.gz

BuildRequires:  gnuxc-glibc-devel

%description
%{summary}.

%package -n gnuxc-libblkid
Summary:        Cross-compiled version of libblkid for the GNU system
License:        LGPLv2

%description -n gnuxc-libblkid
%{summary}.

%package -n gnuxc-libblkid-devel
Summary:        Development files for gnuxc-libblkid
License:        LGPLv2
Requires:       gnuxc-libblkid = %{version}-%{release}

%description -n gnuxc-libblkid-devel
The gnuxc-libblkid-devel package contains libraries and header files for
applications that use libblkid on GNU systems.

%package -n gnuxc-libblkid-static
Summary:        Static libraries of gnuxc-libblkid
License:        LGPLv2
Requires:       gnuxc-libblkid-devel = %{version}-%{release}

%description -n gnuxc-libblkid-static
The gnuxc-libblkid-static package contains the libblkid static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.

%package -n gnuxc-libuuid
Summary:        Cross-compiled version of libuuid for the GNU system
License:        BSD

%description -n gnuxc-libuuid
%{summary}.

%package -n gnuxc-libuuid-devel
Summary:        Development files for gnuxc-libuuid
License:        BSD
Requires:       gnuxc-libuuid = %{version}-%{release}
Requires:       gnuxc-glibc-devel

%description -n gnuxc-libuuid-devel
The gnuxc-libuuid-devel package contains libraries and header files for
applications that use libuuid on GNU systems.

%package -n gnuxc-libuuid-static
Summary:        Static libraries of gnuxc-libuuid
License:        BSD
Requires:       gnuxc-libuuid-devel = %{version}-%{release}

%description -n gnuxc-libuuid-static
The gnuxc-libuuid-static package contains the libuuid static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.


%prep
%autosetup -n %{gnuxc_name}-libs-%{version}
ln lib/uuid/COPYING COPYING.uuid

%build
%gnuxc_configure \
    --disable-fsck \
    --disable-rpath \
    --enable-{blkid,jbd,testio}-debug \
    --enable-elf-shlibs \
    --enable-libblkid \
    --enable-libuuid \
    --enable-threads=posix \
    --enable-verbose-makecmds \
    --without-included-gettext
%gnuxc_make lib/dirpaths.h
%gnuxc_make_build -C lib/uuid all
%gnuxc_make_build -C lib/blkid all

%install
%gnuxc_make_install -C lib/uuid
%gnuxc_make_install -C lib/blkid

# Use a standard mode for static libraries.
chmod -c 0644 %{buildroot}%{gnuxc_libdir}/lib{blk,uu}id.a

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files -n gnuxc-libblkid
%{gnuxc_libdir}/libblkid.so.1
%{gnuxc_libdir}/libblkid.so.1.0
%doc doc/libblkid.txt
%license NOTICE

%files -n gnuxc-libblkid-devel
%{gnuxc_includedir}/blkid
%{gnuxc_libdir}/libblkid.so
%{gnuxc_libdir}/pkgconfig/blkid.pc

%files -n gnuxc-libblkid-static
%{gnuxc_libdir}/libblkid.a

%files -n gnuxc-libuuid
%{gnuxc_libdir}/libuuid.so.1
%{gnuxc_libdir}/libuuid.so.1.2
%doc README.subset
%license COPYING.uuid

%files -n gnuxc-libuuid-devel
%{gnuxc_includedir}/uuid
%{gnuxc_libdir}/libuuid.so
%{gnuxc_libdir}/pkgconfig/uuid.pc

%files -n gnuxc-libuuid-static
%{gnuxc_libdir}/libuuid.a
