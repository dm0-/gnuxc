%?gnuxc_package_header

Name:           gnuxc-readline
Version:        6.3.8
%global basever 6.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
Group:          System Environment/Libraries
URL:            http://www.gnu.org/software/readline/
Source0:        http://ftpmirror.gnu.org/readline/%{gnuxc_name}-%{basever}.tar.gz

Patch001:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-001
Patch002:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-002
Patch003:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-003
Patch004:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-004
Patch005:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-005
Patch006:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-006
Patch007:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-007
Patch008:       http://ftpmirror.gnu.org/readline/readline-%{basever}-patches/readline63-008
Patch101:       %{gnuxc_name}-%{version}-shlib.patch

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-ncurses-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-ncurses-devel

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
%setup -q -n %{gnuxc_name}-%{basever}
%patch001
%patch002
%patch003
%patch004
%patch005
%patch006
%patch007
%patch008
%patch101

%build
%gnuxc_configure \
    --enable-multibyte
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 755 %{buildroot}%{gnuxc_libdir}/lib{history,readline}.so.*.*

# Skip the documentation.
rm -rf \
    %{buildroot}%{gnuxc_datadir}/%{gnuxc_name} \
    %{buildroot}%{gnuxc_docdir} \
    %{buildroot}%{gnuxc_infodir} \
    %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libhistory.so.6
%{gnuxc_libdir}/libhistory.so.6.3
%{gnuxc_libdir}/libreadline.so.6
%{gnuxc_libdir}/libreadline.so.6.3
%doc CHANGELOG CHANGES INSTALL NEWS README USAGE
%license COPYING

%files devel
%{gnuxc_includedir}/readline
%{gnuxc_libdir}/libhistory.so
%{gnuxc_libdir}/libreadline.so

%files static
%{gnuxc_libdir}/libhistory.a
%{gnuxc_libdir}/libreadline.a


%changelog
