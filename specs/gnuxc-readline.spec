%?gnuxc_package_header

Name:           gnuxc-readline
Version:        7.0.3
%global basever 7.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
URL:            http://www.gnu.org/software/readline/
Source0:        http://ftpmirror.gnu.org/readline/%{gnuxc_name}-%{basever}.tar.gz

Patch001:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline70-001
Patch002:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline70-002
Patch003:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline70-003
Patch101:       %{gnuxc_name}-%{version}-shlib.patch

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-ncurses-devel

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
%autosetup -n %{gnuxc_name}-%{basever} -p0

%build
%gnuxc_configure \
    --enable-multibyte \
    --with-curses
%gnuxc_make_build all

%install
%gnuxc_make_install

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 0755 %{buildroot}%{gnuxc_libdir}/lib{history,readline}.so.*.*

# Skip the documentation.
rm -rf \
    %{buildroot}%{gnuxc_datadir}/%{gnuxc_name} \
    %{buildroot}%{gnuxc_docdir} \
    %{buildroot}%{gnuxc_infodir} \
    %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libhistory.so.7
%{gnuxc_libdir}/libhistory.so.7.0
%{gnuxc_libdir}/libreadline.so.7
%{gnuxc_libdir}/libreadline.so.7.0
%doc CHANGELOG CHANGES INSTALL NEWS README USAGE
%license COPYING

%files devel
%{gnuxc_includedir}/readline
%{gnuxc_libdir}/libhistory.so
%{gnuxc_libdir}/libreadline.so

%files static
%{gnuxc_libdir}/libhistory.a
%{gnuxc_libdir}/libreadline.a
