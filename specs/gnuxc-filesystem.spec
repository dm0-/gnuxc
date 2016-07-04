%global bootstrap 1

%global _docdir_fmt gnuxc/filesystem

Name:           gnuxc-filesystem
Version:        1
Release:        1%{?dist}
Summary:        GNU (Hurd) cross-compiler environment and directory structure

License:        GPLv3+
URL:            http://www.dm0.me/projects/gnuxc/

Source0:        %{name}-%{version}-COPYING
Source1:        %{name}-%{version}-macros.gnuxc
Source2:        %{name}-%{version}-config.site

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
test -r %{_fileattrsdir}/elf.attr -a \
    -r %{_fileattrsdir}/libsymlink.attr -a \
    -r %{_fileattrsdir}/pkgconfig.attr

# Pretend a tar was just extracted, so source file numbers are ignored.
for file in %{sources} ; do cp -p $file "${file##*/%{name}-%{version}-}" ; done

# Provide a file configuring automatic library dependencies.
cat << 'EOF' > gnuxc.attr && touch -r macros.gnuxc gnuxc.attr
%%__gnuxc_flags        exeonly
%%__gnuxc_magic        ^(setuid )?(setgid )?(sticky )?ELF 32-bit.*$
%%__gnuxc_path         ^%%{gnuxc_sysroot}/
%%__gnuxc_provides     /bin/sh -c '%%{__elf_provides} | sed "s/.*/gnuxc(&)/"'
%%__gnuxc_requires     /bin/sh -c '%%{__elf_requires} | sed "s/.*/gnuxc(&)/"'
EOF

# Provide a file configuring automatic pkgconfig dependencies.
cat << EOF > gnuxcpkgconfig.attr && touch -r macros.gnuxc gnuxcpkgconfig.attr
%%__gnuxcpkgconfig_provides  /bin/sh -c \
'PKG_CONFIG_LIBDIR=%%{gnuxc_libdir}/pkgconfig %%{__pkgconfig_provides} | \
sed -n "s/^pkgconfig(/gnuxc-&/p"'
%%__gnuxcpkgconfig_requires  /bin/sh -c \
'PKG_CONFIG_LIBDIR=%%{gnuxc_libdir}/pkgconfig %%{__pkgconfig_requires} | \
sed -n "s/^pkgconfig(/gnuxc-&/p;s,.*/pkg-config.*,gnuxc-pkg-config,p"'
%%__gnuxcpkgconfig_path      \
^(%%{gnuxc_libdir}|%%{gnuxc_datadir})/pkgconfig/.*\.pc$
EOF

# Provide a script to pre-expand pkgconfig variables in compiler arguments.
cat << 'EOF' > expand-pc-flags.sh && touch -r macros.gnuxc expand-pc-flags.sh
#!/bin/bash
[ "${RPM_BUILD_ROOT:-/}" = / ] && exit 0 || cd "$RPM_BUILD_ROOT"
shopt -s nullglob
for pc in .{$(rpm -E %%gnuxc_datadir),$(rpm -E %%gnuxc_libdir)}/pkgconfig/*.pc
do
        for var in $(sed -n '/^[^=]*:/s/[^}]*\${\([^}]*\)}[^$]*/\1\n/gp' "$pc")
        do
                val=$(pkg-config --variable="$var" "$pc")
                sed -i -e '/^\(Cflag\|Lib\)s[^=]*:/s,\$'"{$var},$val,g" "$pc"
        done
done
EOF

# Provide a script to extract debuginfo using the cross-binutils.
cat << 'EOF' > find-debuginfo.sh && touch -r macros.gnuxc find-debuginfo.sh
#!/bin/bash
shopt -s expand_aliases
alias nm=$(rpm -E %%gnuxc_nm)
alias objcopy=$(rpm -E %%gnuxc_objcopy)
alias objdump=$(rpm -E %%gnuxc_objdump)
alias readelf=$(rpm -E %%gnuxc_readelf)
. "$(rpm -E %%_rpmconfigdir/find-debuginfo.sh)"
EOF

%build

%install
install -dm 755 \
    %{buildroot}%{_defaultdocdir}/gnuxc \
    %{buildroot}%{_defaultlicensedir}/gnuxc

install -Dpm 644 macros.gnuxc \
    %{buildroot}%{_rpmconfigdir}/macros.d/macros.gnuxc

install -Dpm 644 gnuxc.attr \
    %{buildroot}%{_rpmconfigdir}/fileattrs/gnuxc.attr
install -Dpm 644 gnuxcpkgconfig.attr \
    %{buildroot}%{_rpmconfigdir}/fileattrs/gnuxcpkgconfig.attr

install -Dpm 755 expand-pc-flags.sh \
    %{buildroot}%{_rpmconfigdir}/gnuxc-expand-pc-flags.sh
install -Dpm 755 find-debuginfo.sh \
    %{buildroot}%{_rpmconfigdir}/gnuxc-find-debuginfo.sh

# Build a sysroot directory skeleton.
install -dm 755 \
    %{buildroot}%{gnuxc_root}/{bin,lib} \
    %{buildroot}%{gnuxc_bindir} \
    %{buildroot}%{gnuxc_datadir}/{aclocal,locale,themes,X11,xml} \
    %{buildroot}%{gnuxc_docdir} \
    %{buildroot}%{gnuxc_includedir}/sys \
    %{buildroot}%{gnuxc_infodir} \
    %{buildroot}%{gnuxc_libdir} \
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
%{_rpmconfigdir}/fileattrs/gnuxcpkgconfig.attr
%{_rpmconfigdir}/gnuxc-expand-pc-flags.sh
%{_rpmconfigdir}/gnuxc-find-debuginfo.sh
%{_rpmconfigdir}/macros.d/macros.gnuxc
%license COPYING
