%?gnuxc_package_header

Name:           gnuxc-tiff
Version:        4.0.3
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        libtiff
Group:          System Environment/Libraries
URL:            http://www.remotesensing.org/libtiff/
Source0:        ftp://ftp.remotesensing.org/pub/libtiff/%{gnuxc_name}-%{version}.tar.gz

BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-jbigkit-devel
BuildRequires:  gnuxc-libjpeg-turbo-devel
BuildRequires:  gnuxc-xz-devel
BuildRequires:  gnuxc-zlib-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

%description devel
The %{name}-devel package contains libraries and header files for developing
applications that use %{gnuxc_name} on GNU systems.

%package static
Summary:        Static libraries of %{name}
Group:          Development/Libraries
Requires:       %{name}-devel = %{version}-%{release}

%description static
The %{name}-static package contains the %{gnuxc_name} static libraries for
-static linking on GNU systems.  You don't need these, unless you link
statically, which is highly discouraged.


%prep
%setup -q -n %{gnuxc_name}-%{version}

# Seriously disable rpaths.
sed -i -e 's/\(need_relink\)=yes/\1=no/' config/ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' configure

%build
%gnuxc_configure \
    --disable-rpath \
    --enable-ccitt \
    --enable-check-ycbcr-subsampling \
    --enable-chunky-strip-read \
    --enable-cxx \
    --enable-defer-strile-load \
    --enable-extrasample-as-alpha \
    --enable-jbig \
    --enable-jpeg \
    --enable-jpeg12 --with-jpeg12-include-dir='%{gnuxc_includedir}' \
    --enable-logluv \
    --enable-lzma \
    --enable-lzw \
    --enable-mdi \
    --enable-next \
    --enable-old-jpeg \
    --enable-packbits \
    --enable-pixarlog \
    --enable-strip-chopping \
    --enable-thunder \
    --enable-zlib \
    --with-x
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/{bmp,fax,gif,ppm,ras,raw}2tiff \
    %{buildroot}%{gnuxc_bindir}/{fax2ps,pal2rgb,rgb2ycbcr,thumbnail} \
    %{buildroot}%{gnuxc_bindir}/tiff{2{bw,pdf,ps,rgba},cmp,cp,crop} \
    %{buildroot}%{gnuxc_bindir}/tiff{dither,dump,info,median,set,split}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libtiff{,xx}.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_docdir} %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libtiff.so.5
%{gnuxc_libdir}/libtiff.so.5.2.0
%{gnuxc_libdir}/libtiffxx.so.5
%{gnuxc_libdir}/libtiffxx.so.5.2.0
%doc ChangeLog COPYRIGHT README TODO VERSION

%files devel
%{gnuxc_includedir}/tiff.h
%{gnuxc_includedir}/tiffconf.h
%{gnuxc_includedir}/tiffio.h
%{gnuxc_includedir}/tiffio.hxx
%{gnuxc_includedir}/tiffvers.h
%{gnuxc_libdir}/libtiff.so
%{gnuxc_libdir}/libtiffxx.so
%{gnuxc_libdir}/pkgconfig/libtiff-4.pc

%files static
%{gnuxc_libdir}/libtiff.a
%{gnuxc_libdir}/libtiffxx.a


%changelog
