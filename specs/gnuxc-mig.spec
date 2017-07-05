%global bootstrap 1

%global _docdir_fmt gnuxc/mig

Name:           gnuxc-mig
Version:        1.8
%global commit  b8874015bd1d09b1b72293c0b5be422fd375e04b
%global snap    %(c=%{commit} ; echo -n ${c:0:6})
Release:        1.git%{snap}%{?dist}
Summary:        Cross-compiler version of %{gnuxc_name} for the GNU system

License:        GPLv2
URL:            http://www.gnu.org/software/mig/
Source0:        http://git.savannah.gnu.org/cgit/hurd/%{gnuxc_name}.git/snapshot/%{gnuxc_name}-%{commit}.tar.xz

Patch101:       %{gnuxc_name}-%{version}-%{snap}-drop-perl.patch

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-gnumach-headers

BuildRequires:  automake
BuildRequires:  bison
BuildRequires:  flex
BuildRequires:  flex-devel

Requires:       gnuxc-filesystem

%description
This package provides a cross-compiler version of the Mach Interface Generator
which is used for building GNU Mach and GNU Hurd.


%prep
%setup -q -n %{gnuxc_name}-%{commit}
%patch101
autoreconf -fi

%build
%global _program_prefix %{gnuxc_target}-
%configure \
    --target=%{gnuxc_target}
make %{?_smp_mflags} all \
    TARGET_CPPFLAGS=-I%{gnuxc_includedir}

%install
%make_install

# Provide a cross-tools version of the program.
install -dm 755 %{buildroot}%{gnuxc_root}/bin
ln %{buildroot}%{_bindir}/%{gnuxc_target}-mig %{buildroot}%{gnuxc_root}/bin/mig

%if ! 0%{?bootstrap}
%check
make %{?_smp_mflags} check
%endif


%files
%{_bindir}/%{gnuxc_target}-mig
%{_libexecdir}/%{gnuxc_target}-migcom
%{gnuxc_root}/bin/mig
%doc =announce-* AUTHORS ChangeLog NEWS README
%license COPYING
