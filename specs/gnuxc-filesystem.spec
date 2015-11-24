%global bootstrap 1 # This does nothing other than flag this RPM as pre-glibc.

%global _docdir_fmt gnuxc/filesystem

Name:           gnuxc-filesystem
Version:        1
Release:        1%{?dist}
Summary:        GNU (Hurd) cross-compiler environment and directory structure

License:        GPLv3+
Group:          Development/System
URL:            http://www.gnu.org/

Source0:        %{name}-%{version}-COPYING
Source1:        %{name}-%{version}-macros.gnuxc
Source2:        %{name}-%{version}-config.site
Source3:        %{name}-%{version}-gnuxc.attr
Source4:        %{name}-%{version}-gnuxc-expand-pc-flags.sh
Source5:        %{name}-%{version}-gnuxc-find-debuginfo.sh

Requires:       rpm-build

BuildArch:      noarch

# Load directory macro definitions as if they're installed already.
%{lua:for line in io.lines(rpm.expand("%{SOURCE1}")) do
    if line:sub(1, 7) == "%gnuxc_" and line:sub(-2) ~= "\\" then
        rpm.define(line:sub(2))
    end
end}

%description
This package provides both the directory tree for installing cross-compiled
tools and the RPM macros for building them.


%prep
%setup -c -T

# Verify that some particular file dependencies are still satisfied.
test -r %{_fileattrsdir}/elf.attr -a -r %{_fileattrsdir}/libsymlink.attr

# Pretend a tar was just extracted, so source file numbers are ignored.
for file in %{sources} ; do cp -p $file "${file##*/%{name}-%{version}-}" ; done

%build

%install
install -dm 755 \
    %{buildroot}%{_defaultdocdir}/gnuxc \
    %{buildroot}%{_defaultlicensedir}/gnuxc

install -Dpm 644 macros.gnuxc \
    %{buildroot}%{_rpmconfigdir}/macros.d/macros.gnuxc

install -Dpm 644 gnuxc.attr \
    %{buildroot}%{_rpmconfigdir}/fileattrs/gnuxc.attr

install -Dpm 755 gnuxc-expand-pc-flags.sh \
    %{buildroot}%{_rpmconfigdir}/gnuxc-expand-pc-flags.sh

install -Dpm 755 gnuxc-find-debuginfo.sh \
    %{buildroot}%{_rpmconfigdir}/gnuxc-find-debuginfo.sh

# Build a sysroot directory skeleton.
install -dm 755 \
    %{buildroot}%{gnuxc_root}/{bin,lib} \
    %{buildroot}%{gnuxc_bindir} \
    %{buildroot}%{gnuxc_datadir}/{aclocal,locale,pkgconfig,themes,X11,xml} \
    %{buildroot}%{gnuxc_docdir} \
    %{buildroot}%{gnuxc_includedir}/sys \
    %{buildroot}%{gnuxc_infodir} \
    %{buildroot}%{gnuxc_libdir}/pkgconfig \
    %{buildroot}%{gnuxc_libexecdir} \
    %{buildroot}%{gnuxc_localstatedir}/db \
    %{buildroot}%{gnuxc_mandir}/man{{1..8},l,n} \
    %{buildroot}%{gnuxc_rundir} \
    %{buildroot}%{gnuxc_sbindir} \
    %{buildroot}%{gnuxc_sharedstatedir} \
    %{buildroot}%{gnuxc_sysconfdir}

# Create some compatibility links akin to Fedora paths.
ln -fs usr/bin  %{buildroot}%{gnuxc_sysroot}/
ln -fs usr/lib  %{buildroot}%{gnuxc_sysroot}/
ln -fs usr/sbin %{buildroot}%{gnuxc_sysroot}/
ln -fs ../run   %{buildroot}%{gnuxc_localstatedir}/

# Place a cross-compiler config.site in the sysroot.
install -pm 644 -t %{buildroot}%{gnuxc_datadir} config.site


%files
%{gnuxc_root}
%dir %{_defaultdocdir}/gnuxc
%dir %{_defaultlicensedir}/gnuxc
%{_rpmconfigdir}/fileattrs/gnuxc.attr
%{_rpmconfigdir}/gnuxc-expand-pc-flags.sh
%{_rpmconfigdir}/gnuxc-find-debuginfo.sh
%{_rpmconfigdir}/macros.d/macros.gnuxc
%license COPYING


%changelog
