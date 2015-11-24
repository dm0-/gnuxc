%global bootstrap 1

%?gnuxc_package_header
%global debug_package %{nil}

Name:           gnuxc-gnumach
Version:        1.6
%global snap    4c721d
Release:        1.19700101git%{snap}%{?dist}
Summary:        GNU Mach kernel

License:        CMU and GPLv2
Group:          System Environment/Kernel
URL:            http://www.gnu.org/software/gnumach/
Source0:        http://git.savannah.gnu.org/cgit/hurd/%{gnuxc_name}.git/snapshot/%{gnuxc_name}-%{snap}.tar.xz

BuildRequires:  gnuxc-gcc

BuildRequires:  automake
BuildRequires:  texinfo

%description
This source package holds the GNU Mach kernel, but (at the moment) only a small
subpackage is built from it to provide system headers for cross-compiling.

%package headers
Summary:        System headers from GNU Mach used for cross-compiling
Group:          Development/System
Requires:       gnuxc-filesystem

%description headers
This package provides system headers taken from the GNU Mach kernel source for
use with cross-compilers.


%prep
%setup -q -n %{gnuxc_name}-%{snap}
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


%changelog
