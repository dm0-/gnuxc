%?gnuxc_package_header

Name:           gnuxc-guile
Version:        2.0.9
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+
Group:          Development/Languages
URL:            http://www.gnu.org/software/guile/
Source0:        http://ftp.gnu.org/gnu/guile/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gc-devel
BuildRequires:  gnuxc-libffi-devel
BuildRequires:  gnuxc-ltdl-devel
BuildRequires:  gnuxc-libunistring-devel
BuildRequires:  gnuxc-readline-devel

BuildRequires:  guile

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gc-devel

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

# Call the native guile for guile-config.
sed -i -e 's,@bindir@/,%{_bindir}/,' meta/Makefile.in

# Seriously disable rpaths.
sed -i -e 's/\(need_relink\)=yes/\1=no/' build-aux/ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' configure

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --disable-rpath \
    --disable-silent-rules \
    --enable-debug-malloc \
    --enable-guile-debug \
    --with-threads \
    --without-included-regex
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install
install -dm 755 %{buildroot}%{gnuxc_datadir}/guile/site

# Provide cross-tools versions of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/guile-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-guile-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/{guild,guile,guile-{snarf,tools}}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/lib{guile-2.0,guilereadline-v-18}.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_datadir}/guile
%{gnuxc_libdir}/guile
%{gnuxc_libdir}/libguile-2.0.so.22
%{gnuxc_libdir}/libguile-2.0.so.22.7.0
%{gnuxc_libdir}/libguilereadline-v-18.so.18
%{gnuxc_libdir}/libguilereadline-v-18.so.18.0.0
%doc AUTHORS ChangeLog* COPYING* HACKING LICENSE NEWS README THANKS

%files devel
%{_bindir}/%{gnuxc_target}-guile-config
%{gnuxc_root}/bin/guile-config
%{gnuxc_includedir}/guile
%{gnuxc_libdir}/libguile-2.0.so
%{gnuxc_libdir}/libguilereadline-v-18.so
%{gnuxc_libdir}/pkgconfig/guile-2.0.pc

%files static
%{gnuxc_libdir}/libguile-2.0.a
%{gnuxc_libdir}/libguilereadline-v-18.a


%changelog