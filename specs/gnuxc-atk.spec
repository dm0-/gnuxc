%?gnuxc_package_header

Name:           gnuxc-atk
Version:        2.24.0
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        LGPLv2+
URL:            http://developer.gnome.org/atk/
Source0:        http://ftp.gnome.org/pub/gnome/sources/%{gnuxc_name}/2.24/%{gnuxc_name}-%{version}.tar.xz

BuildRequires:  gnuxc-glib-devel
BuildRequires:  gnuxc-pkg-config

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
    --disable-rpath \
    --disable-silent-rules \
    --enable-static
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libatk-1.0.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_datadir}/gtk-doc

%find_lang %{gnuxc_name}10
while read -r l file ; do rm -f %{buildroot}$file ; done < %{gnuxc_name}10.lang


%files
%{gnuxc_libdir}/libatk-1.0.so.0
%{gnuxc_libdir}/libatk-1.0.so.0.22409.1
%doc AUTHORS ChangeLog MAINTAINERS NEWS README
%license COPYING

%files devel
%{gnuxc_includedir}/atk-1.0
%{gnuxc_libdir}/libatk-1.0.so
%{gnuxc_libdir}/pkgconfig/atk.pc

%files static
%{gnuxc_libdir}/libatk-1.0.a
