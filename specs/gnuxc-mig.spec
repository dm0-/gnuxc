Name:           gnuxc-mig
Version:        1.3.1.99
%global snap    b53836
Release:        1.19700101git%{snap}%{?dist}
Summary:        Cross-compiler version of GNU MIG for Hurd systems

License:        GPLv2
Group:          Development/Languages
URL:            http://www.gnu.org/software/mig/
Source0:        %{gnuxc_name}-%{version}-%{snap}.tar.xz

BuildRequires:  gnuxc-gcc
BuildRequires:  gnuxc-gnumach-headers

BuildRequires:  flex-devel

%description
This package provides a cross-compiler version of the Mach Interface Generator
which is used for building GNU Mach and GNU Hurd.


%prep
%setup -q -n %{gnuxc_name}-%{version}-%{snap}

%build
%global _program_prefix %{gnuxc_target}-
%configure \
    --target=%{gnuxc_target}
make %{?_smp_mflags} all \
    TARGET_CPPFLAGS=-I%{gnuxc_includedir}

%install
%make_install


%files
%{_bindir}/%{gnuxc_target}-mig
%{_libexecdir}/%{gnuxc_target}-migcom
%doc AUTHORS ChangeLog COPYING NEWS README


%changelog
