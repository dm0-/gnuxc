%?gnuxc_package_header

Name:           gnuxc-giflib
Version:        5.1.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://giflib.sourceforge.net/
Source0:        http://prdownloads.sourceforge.net/giflib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-glibc-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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

%build
%gnuxc_configure \
    --disable-silent-rules
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/gif{2raw,2rgb,build,clrmp} \
    %{buildroot}%{gnuxc_bindir}/gif{echo,fix,into,text,tool}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libgif.la


%files
%{gnuxc_libdir}/libgif.so.7
%{gnuxc_libdir}/libgif.so.7.0.0
%doc AUTHORS BUGS ChangeLog COPYING NEWS README TODO

%files devel
%{gnuxc_includedir}/gif_lib.h
%{gnuxc_libdir}/libgif.so

%files static
%{gnuxc_libdir}/libgif.a


%changelog
