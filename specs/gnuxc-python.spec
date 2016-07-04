%?gnuxc_package_header

Name:           gnuxc-python
Version:        3.5.2
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        Python
URL:            http://www.python.org/
Source0:        http://www.python.org/ftp/python/%{version}/Python-%{version}.tar.xz

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
%setup -q -n Python-%{version}

# Hack in some Hurd cross-compiling support.
sed -i -e 's,/usr/include/ncursesw,%{gnuxc_includedir}/ncursesw,' configure configure.ac setup.py
sed -i -e "s/sysconfig.get_config_var('PYTHONFRAMEWORK')/cross_compiling/" setup.py
sed -i -e '/^prefix_real=/s,=.*,=%{gnuxc_prefix},' Misc/python-config.sh.in
sed configure -i \
    -e '/cross build not supported/s/^#*/#/' \
    -e 's/MACHDEP="unknown"/MACHDEP=gnu/g'

# Don't regenerate importlib headers.
sed -i -e '/: /s, Programs/_freeze_importlib$,,' Makefile.pre.in


%build
(%configure --with-pydebug)
make %{?_smp_mflags} {BUILD,}EXE=.native Parser/pgen.native python.native
make clean
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    \
    --enable-big-digits \
    --enable-ipv6 \
    --enable-loadable-sqlite-extensions \
    --enable-shared \
    --with-doc-strings \
    --with-fpectl \
    --with-pydebug \
    --with-pymalloc \
    --with-signal-module \
    --with-system-expat \
    --with-system-ffi \
    --with-threads \
    --with-tsc \
    \
    --without-ensurepip \
    --without-system-libmpdec
sed Makefile -i \
    -e '/^\t[\t ]*.(PGEN)/s,.(PGEN),$(CURDIR)/Parser/pgen.native,' \
    -e '/^PYTHON_FOR_BUILD[ :]*=/s, [^ ]*$, $(CURDIR)/python.native,'
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install -j1

# Provide a cross-tools version of the config script.
install -dm 755 %{buildroot}%{_bindir}
ln %{buildroot}%{gnuxc_root}/bin/python3.5dm-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-python3.5dm-config
ln -s %{gnuxc_target}-python3.5dm-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-python3.5-config
ln -s %{gnuxc_target}-python3.5-config \
    %{buildroot}%{_bindir}/%{gnuxc_target}-python3-config

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_root}/bin/python3{,.5{,dm}}

# This functionality should be used from the system package.
rm -rf \
    %{buildroot}%{gnuxc_libdir}/python3.5 \
    %{buildroot}%{gnuxc_root}/bin/{{2to3,pyvenv}{,-3.5},{idle,pydoc}3{,.5}}
install -dm 755 %{buildroot}%{gnuxc_libdir}/python3.5/site-packages

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libpython3.5dm.so.1.0
%{gnuxc_libdir}/python3.5
%doc Misc/ACKS Misc/HISTORY Misc/NEWS README
%license LICENSE

%files devel
%{_bindir}/%{gnuxc_target}-python3-config
%{_bindir}/%{gnuxc_target}-python3.5-config
%{_bindir}/%{gnuxc_target}-python3.5dm-config
%{gnuxc_root}/bin/python3-config
%{gnuxc_root}/bin/python3.5-config
%{gnuxc_root}/bin/python3.5dm-config
%{gnuxc_includedir}/python3.5dm
%{gnuxc_libdir}/libpython3.5dm.so
%{gnuxc_libdir}/pkgconfig/python3.pc
%{gnuxc_libdir}/pkgconfig/python-3.5.pc
%{gnuxc_libdir}/pkgconfig/python-3.5dm.pc
