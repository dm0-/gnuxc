%?gnuxc_package_header

# This isn't being populated correctly.
%undefine _debugsource_packages

Name:           gnuxc-python
Version:        3.6.4
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        Python
URL:            http://www.python.org/
Source0:        http://www.python.org/ftp/python/%{version}/Python-%{version}.tar.xz

Patch101:       %{gnuxc_name}-%{version}-hurd-port.patch

BuildRequires:  gnuxc-bzip2-devel
BuildRequires:  gnuxc-expat-devel
BuildRequires:  gnuxc-gdbm-devel
BuildRequires:  gnuxc-libffi-devel
BuildRequires:  gnuxc-ncurses-devel
BuildRequires:  gnuxc-readline-devel
BuildRequires:  gnuxc-sqlite-devel
#uildRequires:  gnuxc-tk-devel # Skip tkinter in the sysroot (circular BRs).
BuildRequires:  gnuxc-xz-devel
BuildRequires:  gnuxc-zlib-devel

BuildRequires:  automake
BuildRequires:  python36

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.


%prep
%autosetup -n Python-%{version} -p0

# Make the cross-config script report the prefix in the sysroot.
sed -i -e '/^prefix_real=/s,=.*,=%{gnuxc_prefix},' Misc/python-config.sh.in

# Fix profiling causing recompiles on install.
sed -i -e '/^libainstall:/s/[ \t]all[ \t]/ /g' Makefile.pre.in

autoreconf -fi

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --enable-big-digits \
    --enable-ipv6 \
    --enable-loadable-sqlite-extensions \
    --enable-optimizations \
    --enable-shared \
    --with-doc-strings \
    --with-fpectl \
    --with-lto \
    --with-pymalloc \
    --with-system-expat \
    --with-system-ffi \
    --with-threads \
    \
    --without-ensurepip \
    --without-system-libmpdec \
    CPPFLAGS="`%{gnuxc_pkgconfig} --cflags ncursesw`" \
    MACHDEP=gnu ac_sys_system=GNU
%gnuxc_make_build all

%install
%gnuxc_make_install -j1

# Some libraries lack writeable bits, befuddling the RPM scripts.
chmod -c 0755 %{buildroot}%{gnuxc_libdir}/libpython*

# Provide a cross-tools version of the config script.
install -dm 0755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/python3.6m-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-python3.6m-config
ln -s %{gnuxc_target}-python3.6m-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-python3.6-config
ln -s %{gnuxc_target}-python3.6-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-python3-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/python3{,.6{,m}}

# This functionality should be used from the system package.
rm -rf \
    %{buildroot}%{gnuxc_libdir}/python3.6 \
    %{buildroot}%{gnuxc_root}/bin/{{2to3,pyvenv}{,-3.6},{idle,pydoc}3{,.6}}
install -dm 0755 %{buildroot}%{gnuxc_libdir}/python3.6/site-packages

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpython3.6m.so.1.0
%{gnuxc_libdir}/python3.6
%doc Misc/ACKS Misc/HISTORY Misc/NEWS README.rst
%license LICENSE

%files devel
%{_bindir}/%{gnuxc_target}-python3-config
%{_bindir}/%{gnuxc_target}-python3.6-config
%{_bindir}/%{gnuxc_target}-python3.6m-config
%{gnuxc_root}/bin/python3-config
%{gnuxc_root}/bin/python3.6-config
%{gnuxc_root}/bin/python3.6m-config
%{gnuxc_includedir}/python3.6m
%{gnuxc_libdir}/libpython3.so
%{gnuxc_libdir}/libpython3.6m.so
%{gnuxc_libdir}/pkgconfig/python3.pc
%{gnuxc_libdir}/pkgconfig/python-3.6.pc
%{gnuxc_libdir}/pkgconfig/python-3.6m.pc
