%global bootstrap 1
%global dde 1

%if 0%{?_without_dde:1}
%undefine dde
%endif

%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-gnumach
Version:        1.8
%global commit  fac0a603f8c3280720dc7e6adc16a8b34026508a
%global snap    %(c=%{commit} ; echo -n ${c:0:6})
Release:        1.git%{snap}%{?dist}
Summary:        GNU Mach microkernel

License:        MIT and GPLv2
URL:            http://www.gnu.org/software/gnumach/
Source0:        http://git.savannah.gnu.org/cgit/hurd/%{gnuxc_name}.git/snapshot/%{gnuxc_name}-%{commit}.tar.xz

%if 0%{?dde}
Patch001:       http://git.savannah.gnu.org/cgit/hurd/gnumach.git/rawdiff/?id=457323ebb293739802c6a2e1307cb04a95debe9d&id2=941d462425fb2692fd9ffea1ab03e927697fcfb0#/%{gnuxc_name}-%{version}-dde.patch
%endif

BuildRequires:  gnuxc-gcc

BuildRequires:  automake
BuildRequires:  texinfo

%description
This source package holds the GNU Mach kernel, but (at the moment) only a small
subpackage is built from it to provide system headers for cross-compiling.

%package headers
Summary:        System headers from GNU Mach used for cross-compiling
Requires:       gnuxc-filesystem

%description headers
This package provides system headers taken from the GNU Mach kernel source for
use with cross-compilers.


%prep
%setup -q -n %{gnuxc_name}-%{commit}
%{?dde:%patch001 -p1}
autoreconf -fi

%build
# We don't need (and might not have) glibc at this point.
%gnuxc_configure \
    CC='%{gnuxc_cc} -nostdlib'

%install
%gnuxc_make install-data DESTDIR=%{buildroot}

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_infodir}


%files headers
%{gnuxc_includedir}/mach
%{gnuxc_includedir}/mach_debug
%{gnuxc_includedir}/device
%doc =announce-* AUTHORS ChangeLog DEVELOPMENT NEWS README
%license COPYING
