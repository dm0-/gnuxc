%global bootstrap 1 # This does nothing other than flag this RPM as pre-glibc.

%global _docdir_fmt gnuxc/pkg-config

Name:           gnuxc-pkg-config
Version:        0.29
Release:        1%{?dist}
Summary:        A tool for determining cross-compilation options to GNU systems

License:        GPLv2+
Group:          Development/Tools
URL:            http://pkgconfig.freedesktop.org/
Source0:        http://www.freedesktop.org/software/pkgconfig/releases/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-filesystem

BuildRequires:  glib2-devel

Requires:       gnuxc-filesystem

%description
The pkg-config tool determines compilation options.  For each required library,
it reads the configuration file and outputs the necessary compiler and linker
flags.


%prep
%setup -q -n %{gnuxc_name}-%{version}

%build
%global _program_prefix %{gnuxc_target}-
%configure \
    --disable-host-tool \
    --disable-silent-rules \
    --with-pc-path=%{gnuxc_libdir}/pkgconfig:%{gnuxc_datadir}/pkgconfig \
    --with-system-include-path=%{gnuxc_includedir} \
    --with-system-library-path=%{gnuxc_libdir}:%{gnuxc_sysroot}/lib \
    --without-internal-glib
make %{?_smp_mflags} all

%install
%make_install

# Provide a copy of the binary in the cross-tools bin path.
install -dm 755 %{buildroot}%{gnuxc_root}/bin
ln %{buildroot}%{_bindir}/%{gnuxc_target}-pkg-config \
    %{buildroot}%{gnuxc_root}/bin/pkg-config

# These files conflict with existing installed files.
rm -f %{buildroot}%{_datadir}/aclocal/pkg.m4
rm -f %{buildroot}%{_datadir}/doc/pkg-config/pkg-config-guide.html


%files
%{_bindir}/%{gnuxc_target}-pkg-config
%{gnuxc_root}/bin/pkg-config
%{_mandir}/man1/%{gnuxc_target}-pkg-config.1.gz
%doc AUTHORS ChangeLog NEWS README pkg-config-guide.html
%license COPYING


%changelog
