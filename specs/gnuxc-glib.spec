%?gnuxc_package_header

Name:           gnuxc-glib
Version:        2.48.1
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://developer.gnome.org/glib/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/2.48/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-libffi-devel
BuildRequires:  gnuxc-pcre-devel
BuildRequires:  gnuxc-pkg-config
BuildRequires:  gnuxc-zlib-devel

BuildRequires:  gettext
BuildRequires:  glib2-devel

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

%build
%gnuxc_configure \
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

# There is no need to install binary programs in the sysroot.
rm -f \
    %{buildroot}%{gnuxc_bindir}/{gapplication,gio-querymodules,gsettings} \
    %{buildroot}%{gnuxc_bindir}/gdbus{,-codegen} \
    %{buildroot}%{gnuxc_bindir}/glib-{compile-schemas,compile-resources} \
    %{buildroot}%{gnuxc_bindir}/glib-{genmarshal,gettextize,mkenums} \
    %{buildroot}%{gnuxc_bindir}/{gobject-query,gresource,gtester{,-report}}

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libg{io,lib,module,object,thread}-2.0.la

# This functionality should be used from the system package.
rm -rf %{buildroot}%{gnuxc_datadir}/{aclocal,bash-completion,gdb,gettext}

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc

%find_lang %{gnuxc_name}20
while read -r l file ; do rm -f %{buildroot}$file ; done < %{gnuxc_name}20.lang


%files
%dir %{gnuxc_datadir}/glib-2.0
%dir %{gnuxc_datadir}/glib-2.0/schemas
%{gnuxc_libdir}/gio
%{gnuxc_libdir}/libgio-2.0.so.0
%{gnuxc_libdir}/libgio-2.0.so.0.4800.1
%{gnuxc_libdir}/libglib-2.0.so.0
%{gnuxc_libdir}/libglib-2.0.so.0.4800.1
%{gnuxc_libdir}/libgmodule-2.0.so.0
%{gnuxc_libdir}/libgmodule-2.0.so.0.4800.1
%{gnuxc_libdir}/libgobject-2.0.so.0
%{gnuxc_libdir}/libgobject-2.0.so.0.4800.1
%{gnuxc_libdir}/libgthread-2.0.so.0
%{gnuxc_libdir}/libgthread-2.0.so.0.4800.1
%doc AUTHORS* ChangeLog* NEWS* README
%license COPYING*

%files devel
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
