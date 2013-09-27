%?gnuxc_package_header

Name:           gnuxc-glib
Version:        2.38.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
Group:          System Environment/Libraries
URL:            http://developer.gnome.org/glib/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/2.38/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-libffi-devel
BuildRequires:  gnuxc-libpthread-devel
BuildRequires:  gnuxc-pcre-devel
BuildRequires:  gnuxc-zlib-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libffi-devel
Requires:       gnuxc-libpthread-devel
Requires:       gnuxc-pcre-devel
Requires:       gnuxc-zlib-devel

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
sed -i -e 's/\(need_relink\)=yes/\1=no/' ltmain.sh
sed -i -e 's/\(hardcode_into_libs\)=yes/\1=no/' configure
sed -i -e 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' configure

%build
%gnuxc_configure \
    --disable-modular-tests \
    --disable-silent-rules \
    --enable-debug \
    --enable-gc-friendly \
    --enable-static \
    --enable-xattr \
    --with-pcre=system \
    --with-threads=posix \
    \
    --disable-fam \
    --disable-libelf \
    --disable-selinux
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# Set up sub-package licenses etc. for included documentation.
for doc in */AUTHORS */ChangeLog */COPYING
do
        ln "$doc" "${doc##*/}.${doc%/*}"
done

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libg{io,lib,module,object,thread}-2.0.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/{aclocal,bash-completion,gdb}

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc

%find_lang %{gnuxc_name}20
while read -r l file ; do rm -f %{buildroot}$file ; done < %{gnuxc_name}20.lang


%files
%{gnuxc_bindir}/gdbus
%{gnuxc_bindir}/gio-querymodules
%{gnuxc_bindir}/glib-compile-schemas
%{gnuxc_bindir}/gsettings
%dir %{gnuxc_datadir}/glib-2.0
%dir %{gnuxc_datadir}/glib-2.0/schemas
%{gnuxc_libdir}/gio
%{gnuxc_libdir}/libgio-2.0.so.0
%{gnuxc_libdir}/libgio-2.0.so.0.3800.0
%{gnuxc_libdir}/libglib-2.0.so.0
%{gnuxc_libdir}/libglib-2.0.so.0.3800.0
%{gnuxc_libdir}/libgmodule-2.0.so.0
%{gnuxc_libdir}/libgmodule-2.0.so.0.3800.0
%{gnuxc_libdir}/libgobject-2.0.so.0
%{gnuxc_libdir}/libgobject-2.0.so.0.3800.0
%{gnuxc_libdir}/libgthread-2.0.so.0
%{gnuxc_libdir}/libgthread-2.0.so.0.3800.0
%doc AUTHORS* ChangeLog* COPYING* NEWS* README

%files devel
%{gnuxc_bindir}/gdbus-codegen
%{gnuxc_bindir}/glib-compile-resources
%{gnuxc_bindir}/glib-genmarshal
%{gnuxc_bindir}/glib-gettextize
%{gnuxc_bindir}/glib-mkenums
%{gnuxc_bindir}/gobject-query
%{gnuxc_bindir}/gresource
%{gnuxc_bindir}/gtester
%{gnuxc_bindir}/gtester-report
%{gnuxc_datadir}/glib-2.0/codegen
%{gnuxc_datadir}/glib-2.0/gdb
%{gnuxc_datadir}/glib-2.0/gettext
%{gnuxc_datadir}/glib-2.0/schemas/gschema.dtd
%{gnuxc_includedir}/gio-unix-2.0
%{gnuxc_includedir}/glib-2.0
%{gnuxc_libdir}/glib-2.0
%{gnuxc_libdir}/libgio-2.0.so
%{gnuxc_libdir}/libglib-2.0.so
%{gnuxc_libdir}/libgmodule-2.0.so
%{gnuxc_libdir}/libgobject-2.0.so
%{gnuxc_libdir}/libgthread-2.0.so
%{gnuxc_libdir}/pkgconfig/gio-2.0.pc
%{gnuxc_libdir}/pkgconfig/gio-unix-2.0.pc
%{gnuxc_libdir}/pkgconfig/glib-2.0.pc
%{gnuxc_libdir}/pkgconfig/gmodule-2.0.pc
%{gnuxc_libdir}/pkgconfig/gmodule-export-2.0.pc
%{gnuxc_libdir}/pkgconfig/gmodule-no-export-2.0.pc
%{gnuxc_libdir}/pkgconfig/gobject-2.0.pc
%{gnuxc_libdir}/pkgconfig/gthread-2.0.pc

%files static
%{gnuxc_libdir}/libgio-2.0.a
%{gnuxc_libdir}/libglib-2.0.a
%{gnuxc_libdir}/libgmodule-2.0.a
%{gnuxc_libdir}/libgobject-2.0.a
%{gnuxc_libdir}/libgthread-2.0.a


%changelog
