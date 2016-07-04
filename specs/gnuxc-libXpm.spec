%?gnuxc_package_header

Name:           gnuxc-libXpm
Version:        3.5.11
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libXt-devel
BuildRequires:  gnuxc-pkg-config

BuildRequires:  gettext

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

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
    --disable-silent-rules \
    --enable-stat-zfile \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{cxpm,sxpm}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXpm.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXpm.so.4
%{gnuxc_libdir}/libXpm.so.4.11.0
%doc AUTHORS ChangeLog NEWS.old README
%license COPYING COPYRIGHT

%files devel
%{gnuxc_includedir}/X11/xpm.h
%{gnuxc_libdir}/libXpm.so
%{gnuxc_libdir}/pkgconfig/xpm.pc

%files static
%{gnuxc_libdir}/libXpm.a
