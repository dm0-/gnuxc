Name:           gnuxc-filesystem
Version:        1
Release:        1%{?dist}
Summary:        GNU (Hurd) cross-compiler environment and directory structure

License:        GPLv3+
Group:          Development/System
URL:            http://www.gnu.org/

Source0:        %{name}-%{version}-COPYING
Source1:        %{name}-%{version}-macros.gnuxc
Source2:        %{name}-%{version}-gnuxc.attr
Source3:        %{name}-%{version}-gnuxc-expand-pc-flags.sh
Source4:        %{name}-%{version}-gnuxc-find-debuginfo.sh

Requires:       rpm-build

BuildArch:      noarch

%description
This package provides both the directory tree for installing cross-compiled
tools and the RPM macros for building them.


%prep
%setup -c -T

# Verify that some particular file dependencies are still satisfied.
test -r %{_fileattrsdir}/elf.attr -a -r %{_fileattrsdir}/libsymlink.attr

# Pretend a tar was just extracted, so source file numbers are ignored.
for file in %{sources} ; do cp -p $file "${file##*/%{name}-%{version}-}" ; done

# This shortcut is here so the "real" macros aren't required to build this.
%global root %{_prefix}/i686-pc-gnu
%global _lib lib
%global _libdir %{_prefix}/%{_lib}

%build

%install
install -Dpm 644 macros.gnuxc \
    %{buildroot}%{_sysconfdir}/rpm/macros.gnuxc

install -Dpm 644 gnuxc.attr \
    %{buildroot}%{_rpmconfigdir}/fileattrs/gnuxc.attr

install -Dpm 755 gnuxc-expand-pc-flags.sh \
    %{buildroot}%{_rpmconfigdir}/gnuxc-expand-pc-flags.sh

install -Dpm 755 gnuxc-find-debuginfo.sh \
    %{buildroot}%{_rpmconfigdir}/gnuxc-find-debuginfo.sh

install -dm 755 %{buildroot}%{root}/bin
install -dm 755 %{buildroot}%{root}/lib
install -dm 755 %{buildroot}%{root}/sys-root%{_bindir}
install -dm 755 %{buildroot}%{root}/sys-root%{_datadir}/aclocal
install -dm 755 %{buildroot}%{root}/sys-root%{_datadir}/locale
install -dm 755 %{buildroot}%{root}/sys-root%{_datadir}/pkgconfig
install -dm 755 %{buildroot}%{root}/sys-root%{_datadir}/themes
install -dm 755 %{buildroot}%{root}/sys-root%{_datadir}/xml
install -dm 755 %{buildroot}%{root}/sys-root%{_defaultdocdir}
install -dm 755 %{buildroot}%{root}/sys-root%{_includedir}/sys
install -dm 755 %{buildroot}%{root}/sys-root%{_infodir}
install -dm 755 %{buildroot}%{root}/sys-root%{_libexecdir}
install -dm 755 %{buildroot}%{root}/sys-root%{_localstatedir}/db
install -dm 755 %{buildroot}%{root}/sys-root%{_mandir}/man{{1..8},l,n}
install -dm 755 %{buildroot}%{root}/sys-root%{_libdir}/pkgconfig
install -dm 755 %{buildroot}%{root}/sys-root%{_libdir}/python2.7/site-packages
install -dm 755 %{buildroot}%{root}/sys-root%{_sbindir}
install -dm 755 %{buildroot}%{root}/sys-root%{_sharedstatedir}
install -dm 755 %{buildroot}%{root}/sys-root%{_sysconfdir}

# Create some links to simulate Fedora directory placement outside the prefix.
ln -fs usr/bin  %{buildroot}%{root}/sys-root/
ln -fs usr/lib  %{buildroot}%{root}/sys-root/
ln -fs usr/sbin %{buildroot}%{root}/sys-root/


%files
%{root}
%{_rpmconfigdir}/fileattrs/gnuxc.attr
%{_rpmconfigdir}/gnuxc-expand-pc-flags.sh
%{_rpmconfigdir}/gnuxc-find-debuginfo.sh
%config(noreplace) %{_sysconfdir}/rpm/macros.gnuxc
%doc COPYING


%changelog
