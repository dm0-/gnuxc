%?gnuxc_package_header

Name:           gnuxc-libsndfile
Version:        1.0.28
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+ and GPLv2+ and BSD
URL:            http://www.mega-nerd.com/libsndfile/
Source0:        http://www.mega-nerd.com/libsndfile/files/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-flac-devel
BuildRequires:  gnuxc-libvorbis-devel
BuildRequires:  gnuxc-speex-devel
BuildRequires:  gnuxc-sqlite-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-glibc-devel

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

%build
%gnuxc_configure \
    --disable-silent-rules \
    --disable-werror \
    --enable-cpu-clip \
    --enable-external-libs \
    --enable-experimental \
    --enable-gcc-{opt,pipe} \
    --enable-sqlite \
    --enable-stack-smash-protection \
    \
    --disable-alsa \
    --disable-octave
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/sndfile-{cmp,concat,convert,deinterleave} \
    %{buildroot}%{gnuxc_bindir}/sndfile-{info,interleave,metadata-{g,s}et} \
    %{buildroot}%{gnuxc_bindir}/sndfile-{play,regtest,salvage}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libsndfile.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libsndfile.so.1
%{gnuxc_libdir}/libsndfile.so.%{version}
%doc AUTHORS ChangeLog NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/sndfile.h
%{gnuxc_includedir}/sndfile.hh
%{gnuxc_libdir}/libsndfile.so
%{gnuxc_libdir}/pkgconfig/sndfile.pc

%files static
%{gnuxc_libdir}/libsndfile.a
