%?gnuxc_package_header

# Modifying libtool makes the native guile explode.
%global gnuxc_drop_rpath :

Name:           gnuxc-guile
Version:        2.2.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv3+
URL:            http://www.gnu.org/software/guile/
Source0:        http://ftpmirror.gnu.org/guile/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gc-devel
BuildRequires:  gnuxc-gmp-devel
BuildRequires:  gnuxc-libffi-devel
BuildRequires:  gnuxc-libltdl-devel
BuildRequires:  gnuxc-libunistring-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-readline-devel

BuildRequires:  gc-devel
BuildRequires:  gmp-devel
BuildRequires:  libffi-devel
BuildRequires:  libtool-ltdl-devel
BuildRequires:  libunistring-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gc-devel

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
%autosetup -n %{gnuxc_name}-%{version}

# Call the native guile for guile-config.
sed -i -e 's,@bindir@/,%{_bindir}/,' meta/Makefile.in

%build
%global _configure ../configure
mkdir native && (pushd native
%configure --disable-shared
popd)
%make_build -C native all

%global _configure ./configure
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    GUILE_FOR_BUILD="$PWD/native/meta/guile" \
    \
    --disable-rpath \
    --enable-debug-malloc \
    --enable-guile-debug \
    --with-bdw-gc=bdw-gc \
    --with-threads \
    --without-included-regex
%gnuxc_make_build all \
    ELISP_SOURCES= # Drop this elisp file since it won't cross-compile.

%install
%gnuxc_make_install \
    ELISP_SOURCES= # Drop this elisp file since it won't cross-compile.
install -dm 0755 %{buildroot}%{gnuxc_datadir}/guile/site

# Provide cross-tools versions of the config script.
install -dm 0755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/guile-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-guile-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/{guild,guile,guile-{snarf,tools}}

# We don't need libtool's help.
rm -f \
    %{buildroot}%{gnuxc_libdir}/guile/2.2/extensions/guile-readline.la \
    %{buildroot}%{gnuxc_libdir}/libguile-2.2.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/aclocal

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_datadir}/guile
%dir %{gnuxc_libdir}/guile
%dir %{gnuxc_libdir}/guile/2.2
%{gnuxc_libdir}/guile/2.2/ccache
%dir %{gnuxc_libdir}/guile/2.2/extensions
%{gnuxc_libdir}/guile/2.2/extensions/guile-readline.so.0
%{gnuxc_libdir}/guile/2.2/extensions/guile-readline.so.0.0.0
%{gnuxc_libdir}/libguile-2.2.so.1
%{gnuxc_libdir}/libguile-2.2.so.1.3.0
%doc AUTHORS ChangeLog* HACKING NEWS README THANKS
%license COPYING COPYING.LESSER LICENSE

%files devel
%{_bindir}/%{gnuxc_target}-guile-config
%{gnuxc_root}/bin/guile-config
%{gnuxc_includedir}/guile
%{gnuxc_libdir}/guile/2.2/extensions/guile-readline.so
%{gnuxc_libdir}/libguile-2.2.so
%{gnuxc_libdir}/libguile-2.2.so.1.3.0-gdb.scm
%{gnuxc_libdir}/pkgconfig/guile-2.2.pc

%files static
%{gnuxc_libdir}/guile/2.2/extensions/guile-readline.a
%{gnuxc_libdir}/libguile-2.2.a
