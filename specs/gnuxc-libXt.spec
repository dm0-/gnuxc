%?gnuxc_package_header

Name:           gnuxc-libXt
Version:        1.1.4
Release:        1%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        MIT
Group:          System Environment/Libraries
URL:            http://www.x.org/
Source0:        http://xorg.freedesktop.org/releases/individual/lib/%{gnuxc_name}-%{version}.tar.bz2

BuildRequires:  gnuxc-libSM-devel
BuildRequires:  gnuxc-libX11-devel

BuildArch:      noarch

%description
%{summary}.

%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}
Requires:       gnuxc-libSM-devel
Requires:       gnuxc-libX11-devel

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

sed -i -e '/^app/{s,@appdefaultdir@,${datarootdir}/X11/app-defaults,g;N;s/\(.*\)\n\(.*\)/\2\n\1/}' xt.pc.in

%build
%gnuxc_configure \
    --disable-specs \
    \
    --disable-silent-rules \
    --enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
    --enable-xkb \
    --with-glib \
    --with-perl
%gnuxc_make %{?_smp_mflags} all

%install
%gnuxc_make_install

# We don't need libtool's help.
rm -f %{buildroot}%{gnuxc_libdir}/libXt.la

# Skip the documentation.
rm -rf %{buildroot}%{gnuxc_mandir}


%files
%{gnuxc_libdir}/libXt.so.6
%{gnuxc_libdir}/libXt.so.6.0.0
%doc ChangeLog COPYING README

%files devel
%{gnuxc_includedir}/X11/CallbackI.h
%{gnuxc_includedir}/X11/Composite.h
%{gnuxc_includedir}/X11/CompositeP.h
%{gnuxc_includedir}/X11/ConstrainP.h
%{gnuxc_includedir}/X11/Constraint.h
%{gnuxc_includedir}/X11/ConvertI.h
%{gnuxc_includedir}/X11/Core.h
%{gnuxc_includedir}/X11/CoreP.h
%{gnuxc_includedir}/X11/CreateI.h
%{gnuxc_includedir}/X11/EventI.h
%{gnuxc_includedir}/X11/HookObjI.h
%{gnuxc_includedir}/X11/InitialI.h
%{gnuxc_includedir}/X11/Intrinsic.h
%{gnuxc_includedir}/X11/IntrinsicI.h
%{gnuxc_includedir}/X11/IntrinsicP.h
%{gnuxc_includedir}/X11/Object.h
%{gnuxc_includedir}/X11/ObjectP.h
%{gnuxc_includedir}/X11/PassivGraI.h
%{gnuxc_includedir}/X11/RectObj.h
%{gnuxc_includedir}/X11/RectObjP.h
%{gnuxc_includedir}/X11/ResConfigP.h
%{gnuxc_includedir}/X11/ResourceI.h
%{gnuxc_includedir}/X11/SelectionI.h
%{gnuxc_includedir}/X11/Shell.h
%{gnuxc_includedir}/X11/ShellI.h
%{gnuxc_includedir}/X11/ShellP.h
%{gnuxc_includedir}/X11/StringDefs.h
%{gnuxc_includedir}/X11/ThreadsI.h
%{gnuxc_includedir}/X11/TranslateI.h
%{gnuxc_includedir}/X11/VarargsI.h
%{gnuxc_includedir}/X11/Vendor.h
%{gnuxc_includedir}/X11/VendorP.h
%{gnuxc_includedir}/X11/Xtos.h
%{gnuxc_libdir}/libXt.so
%{gnuxc_libdir}/pkgconfig/xt.pc

%files static
%{gnuxc_libdir}/libXt.a


%changelog
