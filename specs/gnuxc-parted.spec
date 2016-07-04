%?gnuxc_package_header

Name:           gnuxc-parted
Version:        3.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
URL:            http://www.gnu.org/software/parted/
Source0:        http://ftpmirror.gnu.org/%{gnuxc_name}/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-hurd-devel
BuildRequires:  gnuxc-libuuid-devel
BuildRequires:  gnuxc-ncurses-devel
BuildRequires:  gnuxc-readline-devel

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

%build
%gnuxc_configure \
    --disable-nls \
    \
    --disable-device-mapper \
    --disable-rpath \
    --disable-silent-rules \
    --enable-assert \
    --enable-debug \
    --enable-gcc-warnings gl_cv_warn_c__Werror=no \
    --enable-threads=posix \
    --with-readline \
    --without-included-regex
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_sbindir}/{parted,partprobe}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libparted{,-fs-resize}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libparted.so.2
%{gnuxc_libdir}/libparted.so.2.0.1
%{gnuxc_libdir}/libparted-fs-resize.so.0
%{gnuxc_libdir}/libparted-fs-resize.so.0.0.1
%doc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
%license COPYING

%files devel
%{gnuxc_includedir}/parted
%{gnuxc_libdir}/libparted.so
%{gnuxc_libdir}/libparted-fs-resize.so
%{gnuxc_libdir}/pkgconfig/libparted.pc

%files static
%{gnuxc_libdir}/libparted.a
%{gnuxc_libdir}/libparted-fs-resize.a
