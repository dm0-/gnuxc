%?gnuxc_package_header

Name:           gnuxc-libtool
Version:        2.4.6
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv2+ and LGPLv2+ and GFDL
URL:            http://www.gnu.org/software/libtool/
Source0:        http://ftpmirror.gnu.org/libtool/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glibc-devel

BuildRequires:  help2man
BuildRequires:  m4

%description
%{summary}.

%package -n gnuxc-libltdl
Summary:        Cross-compiled version of libltdl for the GNU system
License:        LGPLv2+

%description -n gnuxc-libltdl
Cross-compiled version of libltdl for the GNU system.

%package -n gnuxc-libltdl-devel
Summary:        Development files for gnuxc-libltdl
License:        LGPLv2+
Requires:       gnuxc-libltdl = %{version}-%{release}
Requires:       gnuxc-glibc-devel

%description -n gnuxc-libltdl-devel
The gnuxc-libltdl-devel package contains libraries and header files for
developing applications that use libltdl on GNU systems.

%package -n gnuxc-libltdl-static
Summary:        Static libraries of gnuxc-libltdl
License:        LGPLv2+
Requires:       gnuxc-libltdl-devel = %{version}-%{release}

%description -n gnuxc-libltdl-static
The gnuxc-libltdl-static package contains the libltdl static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Regenerate this to avoid edits by the anti-rpath scripts.
rm -f build-aux/ltmain.sh

%build
%gnuxc_configure \
    --disable-silent-rules \
    --enable-ltdl-install
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libltdl.la

# This functionality should be used from the system package.
rm -rf \
    %{buildroot}%{gnuxc_bindir}/{libtool,libtoolize} \
    %{buildroot}%{gnuxc_datadir}/{aclocal,libtool}

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files -n gnuxc-libltdl
%{gnuxc_libdir}/libltdl.so.7
%{gnuxc_libdir}/libltdl.so.7.3.1
%doc AUTHORS ChangeLog* NEWS README THANKS TODO
%license COPYING

%files -n gnuxc-libltdl-devel
%{gnuxc_includedir}/libltdl
%{gnuxc_includedir}/ltdl.h
%{gnuxc_libdir}/libltdl.so

%files -n gnuxc-libltdl-static
%{gnuxc_libdir}/libltdl.a
