%?gnuxc_package_header

Name:           gnuxc-attr
Version:        2.4.47
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://savannah.nongnu.org/projects/attr
Source0:        http://download.savannah.gnu.org/releases/attr/%{gnuxc_name}-%{version}.src.tar.gz

BuildRequires:  gnuxc-glibc-devel

BuildRequires:  gettext

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
%autosetup -n %{gnuxc_name}-%{version}

%build
%gnuxc_configure \
    PLATFORM=gnu
%gnuxc_make_build

%install
%gnuxc_make_install install-lib install-dev

# There is no need to install binary programs in the sysroot.
rm -f %{buildroot}%{gnuxc_bindir}/{attr,getfattr,setfattr}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libattr.la

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 0755 %{buildroot}%{gnuxc_libdir}/libattr.so.1.1.0

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_mandir}

rm -f %{buildroot}%{gnuxc_datadir}/locale/??/LC_MESSAGES/attr.mo


%files
%{gnuxc_libdir}/libattr.so.1
%{gnuxc_libdir}/libattr.so.1.1.0
%doc doc/CHANGES doc/PORTING README
%license doc/COPYING doc/COPYING.LGPL

%files devel
%{gnuxc_includedir}/attr
%{gnuxc_libdir}/libattr.so

%files static
%{gnuxc_libdir}/libattr.a
