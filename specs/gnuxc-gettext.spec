%?gnuxc_package_header

Name:           gnuxc-gettext
Version:        0.19.6
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+ and LGPLv2+
Group:          Development/Tools
URL:            http://www.gnu.org/software/gettext/
Source0:        http://ftpmirror.gnu.org/gettext/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-gcc-c++
BuildRequires:  gnuxc-acl-devel
BuildRequires:  gnuxc-expat-devel
BuildRequires:  gnuxc-libcroco-devel
BuildRequires:  gnuxc-libunistring-devel
BuildRequires:  gnuxc-ncurses-devel

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-gcc-c++

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
sed -i -e 's/\(need_relink\)=yes/\1=no/' build-aux/ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' gettext-tools/configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__BAD_LIBTOOL__/' gettext-tools/configure

%build
%gnuxc_configure \
    --disable-nls \
    \
    --disable-rpath \
    --enable-acl \
    --enable-c++ \
    --enable-curses \
    --enable-libasprintf \
    --enable-openmp \
    --enable-threads=posix \
    --with-bzip2 \
    --with-emacs \
    --with-xz \
    --without-included-gettext \
    --without-included-glib \
    --without-included-libcroco \
    --without-included-libunistring \
    --without-included-libxml \
    --without-included-regex \
    \
    --disable-java
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install -j1

# Set up sub-package licenses etc. for included documentation.
for doc in */AUTHORS */BUGS */ChangeLog */COPYING */NEWS */README
do
        ln "$doc" "${doc##*/}.${doc%/*}"
done

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/autopoint \
    %{buildroot}%{gnuxc_bindir}/envsubst \
    %{buildroot}%{gnuxc_bindir}/gettext{,.sh,ize} \
    %{buildroot}%{gnuxc_bindir}/msg{attrib,cat,cmp,comm,conv,en,exec} \
    %{buildroot}%{gnuxc_bindir}/msg{filter,fmt,grep,init,merge,unfmt,uniq} \
    %{buildroot}%{gnuxc_bindir}/{n,x}gettext \
    %{buildroot}%{gnuxc_bindir}/recode-sr-latin \
    %{buildroot}%{gnuxc_libdir}/gettext/{cldr-plurals,hostname} \
    %{buildroot}%{gnuxc_libdir}/gettext/{project-id,urlget,user-email}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/lib{asprintf,gettext{lib,po,src}}.la

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 755 %{buildroot}%{gnuxc_libdir}/preloadable_libintl.so

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/{aclocal,emacs,gettext}

# Skip the documentation.
rm -rf %{buildroot}{%{gnuxc_docdir},%{gnuxc_infodir},%{gnuxc_mandir}}


%files
%{gnuxc_libdir}/libasprintf.so.0
%{gnuxc_libdir}/libasprintf.so.0.0.0
%{gnuxc_libdir}/libgettextlib-%{version}.so
%{gnuxc_libdir}/libgettextpo.so.0
%{gnuxc_libdir}/libgettextpo.so.0.5.3
%{gnuxc_libdir}/libgettextsrc-%{version}.so
%doc AUTHORS* BUGS* ChangeLog* HACKING NEWS* PACKAGING README* THANKS
%license COPYING*

%files devel
%{gnuxc_includedir}/autosprintf.h
%{gnuxc_includedir}/gettext-po.h
%{gnuxc_libdir}/libasprintf.so
%{gnuxc_libdir}/libgettextlib.so
%{gnuxc_libdir}/libgettextpo.so
%{gnuxc_libdir}/libgettextsrc.so
%{gnuxc_libdir}/preloadable_libintl.so

%files static
%{gnuxc_libdir}/libasprintf.a
%{gnuxc_libdir}/libgettextpo.a


%changelog
