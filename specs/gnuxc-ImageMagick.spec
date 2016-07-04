%?gnuxc_package_header

Name:           gnuxc-ImageMagick
Version:        7.0.2
%global snap    2
%global flavor  7.Q16HDRI
Release:        1.%{snap}%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        ImageMagick
URL:            http://www.imagemagick.org/
Source0:        http://www.imagemagick.org/download/releases/%{gnuxc_name}-%{version}-%{snap}.tar.xz

BuildRequires:  gnuxc-bzip2-devel
BuildRequires:  gnuxc-jbigkit-devel
BuildRequires:  gnuxc-libjpeg-turbo-devel
BuildRequires:  gnuxc-libltdl-devel
BuildRequires:  gnuxc-librsvg-devel
BuildRequires:  gnuxc-libwebp-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-xz-devel

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
%setup -q -n %{gnuxc_name}-%{version}-%{snap}

%build
%gnuxc_configure \
    --bindir=%{gnuxc_root}/bin \
    --disable-docs \
    \
    --enable-bounds-checking \
    --enable-hdri \
    --enable-hugepages \
    --enable-openmp \
    --disable-silent-rules \
    --with-bzlib \
    --with-fontconfig \
    --with-freetype \
    --with-jbig \
    --with-jpeg \
    --with-lzma \
    --with-magick-plus-plus \
    --with-modules \
    --with-pango \
    --with-png \
    --with-rsvg \
    --with-tiff \
    --with-webp \
    --with-x \
    --with-xml \
    --with-zlib \
    \
    --enable-assert \
    --without-perl \
    \
    --disable-opencl \
    --without-autotrace \
    --without-djvu \
    --without-dps \
    --without-fftw \
    --without-fpx \
    --without-gslib \
    --without-gvc \
    --without-lcms \
    --without-lqr \
    --without-openexr \
    --without-openjp2 \
    --without-wmf
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Provide a cross-tools version of the config scripts.
install -dm 755 %{buildroot}%{_bindir}
for prog in Magick{++,Core,Wand}
do
        ln %{buildroot}%{gnuxc_root}/bin/$prog-config \
            %{buildroot}%{_bindir}/%{gnuxc_target}-$prog-config
done

# There is no need to install binary programs in the sysroot.
rm -f \
     %{buildroot}%{gnuxc_root}/bin/{animate,compare,composite,conjure} \
     %{buildroot}%{gnuxc_root}/bin/{convert,display,identify,import} \
     %{buildroot}%{gnuxc_root}/bin/{magick{,-script},mogrify,montage,stream}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libMagick{++,Core,Wand}-%{flavor}.la
rm -f %{buildroot}%{gnuxc_libdir}/ImageMagick-%{version}/modules-Q16HDRI/*/*.la


%files
%{gnuxc_datadir}/ImageMagick-7
%{gnuxc_libdir}/ImageMagick-%{version}
%{gnuxc_libdir}/libMagick++-%{flavor}.so.0
%{gnuxc_libdir}/libMagick++-%{flavor}.so.0.0.0
%{gnuxc_libdir}/libMagickCore-%{flavor}.so.0
%{gnuxc_libdir}/libMagickCore-%{flavor}.so.0.0.0
%{gnuxc_libdir}/libMagickWand-%{flavor}.so.0
%{gnuxc_libdir}/libMagickWand-%{flavor}.so.0.0.0
%{gnuxc_sysconfdir}/ImageMagick-7
%doc AUTHORS.txt ChangeLog NEWS.txt README.txt
%license LICENSE NOTICE

%files devel
%{_bindir}/%{gnuxc_target}-Magick++-config
%{_bindir}/%{gnuxc_target}-MagickCore-config
%{_bindir}/%{gnuxc_target}-MagickWand-config
%{gnuxc_root}/bin/Magick++-config
%{gnuxc_root}/bin/MagickCore-config
%{gnuxc_root}/bin/MagickWand-config
%{gnuxc_includedir}/ImageMagick-7
%{gnuxc_libdir}/libMagick++-%{flavor}.so
%{gnuxc_libdir}/libMagickCore-%{flavor}.so
%{gnuxc_libdir}/libMagickWand-%{flavor}.so
%{gnuxc_libdir}/pkgconfig/ImageMagick.pc
%{gnuxc_libdir}/pkgconfig/ImageMagick-%{flavor}.pc
%{gnuxc_libdir}/pkgconfig/Magick++.pc
%{gnuxc_libdir}/pkgconfig/Magick++-%{flavor}.pc
%{gnuxc_libdir}/pkgconfig/MagickCore.pc
%{gnuxc_libdir}/pkgconfig/MagickCore-%{flavor}.pc
%{gnuxc_libdir}/pkgconfig/MagickWand.pc
%{gnuxc_libdir}/pkgconfig/MagickWand-%{flavor}.pc

%files static
%{gnuxc_libdir}/libMagick++-%{flavor}.a
%{gnuxc_libdir}/libMagickCore-%{flavor}.a
%{gnuxc_libdir}/libMagickWand-%{flavor}.a
