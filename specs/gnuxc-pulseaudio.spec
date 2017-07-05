%?gnuxc_package_header

Name:           gnuxc-pulseaudio
Version:        10.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://www.freedesktop.org/wiki/Software/PulseAudio/
Source0:        http://www.freedesktop.org/software/pulseaudio/releases/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-gdbm-devel
BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-gtk+-devel
BuildRequires:  gnuxc-json-c-devel
BuildRequires:  gnuxc-libltdl-devel
BuildRequires:  gnuxc-libSM-devel
BuildRequires:  gnuxc-libsndfile-devel
BuildRequires:  gnuxc-libXtst-devel
BuildRequires:  gnuxc-speexdsp-devel

BuildRequires:  intltool
BuildRequires:  m4

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}

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
%setup -q -n %{gnuxc_name}-%{version}

# Don't expect Solaris headers.
sed -i -e 's,<sys/conf.h>,<sys/poll.h>,' src/modules/module-solaris.c

%build
%gnuxc_configure \
    --disable-legacy-database-entry-format \
    --disable-rpath \
    --disable-silent-rules \
    --disable-static-bins \
    --enable-glib2 \
    --enable-gtk3 \
    --enable-ipv6 \
    --enable-solaris \
    --enable-static \
    --enable-x11 \
    --with-database=gdbm \
    --with-speex \
    \
    --disable-oss-{output,wrapper}
%gnuxc_make %{?_smp_mflags} all \
    pkglibdir=%{gnuxc_libdir}

%install
%gnuxc_make_install \
    pkglibdir=%{gnuxc_libdir}

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/{esdcompat,pasuspender,pulseaudio} \
    %{buildroot}%{gnuxc_bindir}/pa{cat,cmd,ctl,dsp,mon,play,rec,record} \
    %{buildroot}%{gnuxc_bindir}/{pax11publish,start-pulseaudio-x11}

# We don't need libtool's help.
rm -f \
    %{buildroot}%{gnuxc_libdir}/libpulse{,-mainloop-glib,-simple}.la \
    %{buildroot}%{gnuxc_libdir}/libpulse{common,core}-%{version}.la

# This functionality should be used from the system package.
rm -rf \
    %{buildroot}%{gnuxc_datadir}/{bash-completion,vala,zsh} \
    %{buildroot}%{gnuxc_libdir}/cmake \
    %{buildroot}%{gnuxc_sysconfdir}/xdg

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}

%find_lang %{gnuxc_name}
while read -r l file ; do rm -f %{buildroot}$file ; done < %{gnuxc_name}.lang


%files
%{gnuxc_libdir}/libpulse.so.0
%{gnuxc_libdir}/libpulse.so.0.20.1
%{gnuxc_libdir}/libpulse-mainloop-glib.so.0
%{gnuxc_libdir}/libpulse-mainloop-glib.so.0.0.5
%{gnuxc_libdir}/libpulse-simple.so.0
%{gnuxc_libdir}/libpulse-simple.so.0.1.0
%{gnuxc_libdir}/libpulsecommon-%{version}.so
%{gnuxc_libdir}/libpulsecore-%{version}.so
%dir %{gnuxc_libdir}/pulse-%{version}
%dir %{gnuxc_libdir}/pulse-%{version}/modules
%{gnuxc_libdir}/pulse-%{version}/modules/lib*.so
%{gnuxc_libdir}/pulse-%{version}/modules/module-*.so
%{gnuxc_sysconfdir}/pulse
%doc NEWS PROTOCOL README todo
%license GPL LGPL LICENSE

%files devel
%{gnuxc_includedir}/pulse
%{gnuxc_libdir}/libpulse.so
%{gnuxc_libdir}/libpulse-mainloop-glib.so
%{gnuxc_libdir}/libpulse-simple.so
%{gnuxc_libdir}/pkgconfig/libpulse.pc
%{gnuxc_libdir}/pkgconfig/libpulse-mainloop-glib.pc
%{gnuxc_libdir}/pkgconfig/libpulse-simple.pc

%files static
%{gnuxc_libdir}/libpulse.a
%{gnuxc_libdir}/libpulse-mainloop-glib.a
%{gnuxc_libdir}/libpulse-simple.a
%{gnuxc_libdir}/libpulsecommon-%{version}.a
%{gnuxc_libdir}/libpulsecore-%{version}.a
%{gnuxc_libdir}/pulse-%{version}/modules/lib*.a
%{gnuxc_libdir}/pulse-%{version}/modules/module-*.a
