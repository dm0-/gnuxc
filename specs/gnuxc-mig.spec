Name:           gnuxc-mig
Version:        1.4
%global snap    5a2d1f
Release:        1.19700101git%{snap}%{?dist}
Summary:        Cross-compiler version of GNU MIG for Hurd systems

License:        GPLv2
Group:          Development/Languages
URL:            http://www.gnu.org/software/mig/
Source0:        http://git.savannah.gnu.org/cgit/hurd/%{gnuxc_name}.git/snapshot/%{gnuxc_name}-%{snap}.tar.xz

Patch101:       %{gnuxc_name}-%{version}-%{snap}-drop-perl.patch

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-gnumach-headers

BuildRequires:  flex-devel

Requires:       gnuxc-filesystem

%description
This package provides a cross-compiler version of the Mach Interface Generator
which is used for building GNU Mach and GNU Hurd.


%prep
%setup -q -n %{gnuxc_name}-%{snap}
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


%files
%{_bindir}/%{gnuxc_target}-mig
%{_libexecdir}/%{gnuxc_target}-migcom
%{gnuxc_root}/bin/mig
%doc =announce-* AUTHORS ChangeLog COPYING NEWS README


%changelog
