%?gnuxc_package_header

Name:           gnuxc-ncurses
Version:        5.9
%global snap    20140322
Release:        1.19700101snap%{snap}%{?dist}
Summary:        Cross-compiled version of %{gnuxc_name} for the GNU system

License:        GPLv3+
Group:          Applications/System
URL:            http://www.gnu.org/software/ncurses/
Source0:        ftp://invisible-island.net/ncurses/current/%{gnuxc_name}-%{version}-%{snap}.tgz

BuildRequires:  gnuxc-gcc-c++

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
%setup -q -n %{gnuxc_name}-%{version}-%{snap}

%build
%global _configure ../configure
%global ncurses_configuration \\\
    --bindir=%{gnuxc_root}/bin \\\
    --without-manpages \\\
    --without-progs \\\
    \\\
    --disable-relink \\\
    --disable-rpath \\\
    --disable-rpath-hack \\\
    --enable-assertions \\\
    --enable-colorfgbg \\\
    --enable-overwrite \\\
    --enable-pc-files --with-pkg-config-libdir='%{gnuxc_libdir}/pkgconfig' \\\
    --enable-warnings \\\
    --with-debug \\\
    --with-shared --with-cxx-shared \\\
    --with-termlib \\\
    --with-ticlib \\\
    --without-dlsym \\\
    \\\
    --without-gpm
mkdir -p classic && pushd classic
%gnuxc_configure %{ncurses_configuration} \
    --includedir='${prefix}/include/ncurses'
popd
mkdir -p pthread && pushd pthread
%gnuxc_configure %{ncurses_configuration} \
    --includedir='${prefix}/include/ncursest' \
    --with-pthread
popd
mkdir -p widec && pushd widec
%gnuxc_configure %{ncurses_configuration} \
    --includedir='${prefix}/include/ncursesw' \
    --enable-ext-colors \
    --enable-widec
popd
mkdir -p widec+pthread && pushd widec+pthread
%gnuxc_configure %{ncurses_configuration} \
    --includedir='${prefix}/include/ncursestw' \
    --enable-ext-colors \
    --enable-widec \
    --with-pthread
popd
%gnuxc_make -C classic       %{?_smp_mflags} libs
%gnuxc_make -C pthread       %{?_smp_mflags} libs
%gnuxc_make -C widec         %{?_smp_mflags} libs
%gnuxc_make -C widec+pthread %{?_smp_mflags} all

%install
%gnuxc_make -C classic       install.libs DESTDIR=%{buildroot}
%gnuxc_make -C pthread       install.libs DESTDIR=%{buildroot}
%gnuxc_make -C widec         install.libs DESTDIR=%{buildroot}
%gnuxc_make -C widec+pthread install      DESTDIR=%{buildroot}

# Provide a cross-tools version of the config scripts.
install -dm 755 %{buildroot}%{_bindir}
for lib in 5 t6 tw6 w6
do
        ln %{buildroot}%{gnuxc_root}/bin/ncurses$lib-config \
            %{buildroot}%{_bindir}/%{gnuxc_target}-ncurses$lib-config
done

# Some libraries lack executable bits, befuddling the RPM scripts.
chmod -c 755 %{buildroot}%{gnuxc_libdir}/lib*.so.*.*

# This isn't needed, especially not in the library path.
rm -f %{buildroot}%{gnuxc_libdir}/terminfo


%files
%{gnuxc_libdir}/libform.so.5
%{gnuxc_libdir}/libform.so.5.9
%{gnuxc_libdir}/libformt.so.6
%{gnuxc_libdir}/libformt.so.6.0
%{gnuxc_libdir}/libformtw.so.6
%{gnuxc_libdir}/libformtw.so.6.0
%{gnuxc_libdir}/libformw.so.6
%{gnuxc_libdir}/libformw.so.6.0
%{gnuxc_libdir}/libmenu.so.5
%{gnuxc_libdir}/libmenu.so.5.9
%{gnuxc_libdir}/libmenut.so.6
%{gnuxc_libdir}/libmenut.so.6.0
%{gnuxc_libdir}/libmenutw.so.6
%{gnuxc_libdir}/libmenutw.so.6.0
%{gnuxc_libdir}/libmenuw.so.6
%{gnuxc_libdir}/libmenuw.so.6.0
%{gnuxc_libdir}/libncurses.so.5
%{gnuxc_libdir}/libncurses.so.5.9
%{gnuxc_libdir}/libncursest.so.6
%{gnuxc_libdir}/libncursest.so.6.0
%{gnuxc_libdir}/libncursestw.so.6
%{gnuxc_libdir}/libncursestw.so.6.0
%{gnuxc_libdir}/libncursesw.so.6
%{gnuxc_libdir}/libncursesw.so.6.0
%{gnuxc_libdir}/libncurses++.so.5
%{gnuxc_libdir}/libncurses++.so.5.9
%{gnuxc_libdir}/libncurses++t.so.6
%{gnuxc_libdir}/libncurses++t.so.6.0
%{gnuxc_libdir}/libncurses++tw.so.6
%{gnuxc_libdir}/libncurses++tw.so.6.0
%{gnuxc_libdir}/libncurses++w.so.6
%{gnuxc_libdir}/libncurses++w.so.6.0
%{gnuxc_libdir}/libpanel.so.5
%{gnuxc_libdir}/libpanel.so.5.9
%{gnuxc_libdir}/libpanelt.so.6
%{gnuxc_libdir}/libpanelt.so.6.0
%{gnuxc_libdir}/libpaneltw.so.6
%{gnuxc_libdir}/libpaneltw.so.6.0
%{gnuxc_libdir}/libpanelw.so.6
%{gnuxc_libdir}/libpanelw.so.6.0
%{gnuxc_libdir}/libtic.so.5
%{gnuxc_libdir}/libtic.so.5.9
%{gnuxc_libdir}/libtict.so.6
%{gnuxc_libdir}/libtict.so.6.0
%{gnuxc_libdir}/libtictw.so.6
%{gnuxc_libdir}/libtictw.so.6.0
%{gnuxc_libdir}/libticw.so.6
%{gnuxc_libdir}/libticw.so.6.0
%{gnuxc_libdir}/libtinfo.so.5
%{gnuxc_libdir}/libtinfo.so.5.9
%{gnuxc_libdir}/libtinfot.so.6
%{gnuxc_libdir}/libtinfot.so.6.0
%{gnuxc_libdir}/libtinfotw.so.6
%{gnuxc_libdir}/libtinfotw.so.6.0
%{gnuxc_libdir}/libtinfow.so.6
%{gnuxc_libdir}/libtinfow.so.6.0
%{gnuxc_datadir}/tabset
%{gnuxc_datadir}/terminfo
%doc ANNOUNCE AUTHORS INSTALL NEWS README TO-DO

%files devel
%{_bindir}/%{gnuxc_target}-ncurses5-config
%{_bindir}/%{gnuxc_target}-ncursest6-config
%{_bindir}/%{gnuxc_target}-ncursestw6-config
%{_bindir}/%{gnuxc_target}-ncursesw6-config
%{gnuxc_root}/bin/ncurses5-config
%{gnuxc_root}/bin/ncursest6-config
%{gnuxc_root}/bin/ncursestw6-config
%{gnuxc_root}/bin/ncursesw6-config
%{gnuxc_includedir}/ncurses
%{gnuxc_includedir}/ncursest
%{gnuxc_includedir}/ncursestw
%{gnuxc_includedir}/ncursesw
%{gnuxc_libdir}/libcurses.so
%{gnuxc_libdir}/libform.so
%{gnuxc_libdir}/libformt.so
%{gnuxc_libdir}/libformtw.so
%{gnuxc_libdir}/libformw.so
%{gnuxc_libdir}/libmenu.so
%{gnuxc_libdir}/libmenut.so
%{gnuxc_libdir}/libmenutw.so
%{gnuxc_libdir}/libmenuw.so
%{gnuxc_libdir}/libncurses.so
%{gnuxc_libdir}/libncursest.so
%{gnuxc_libdir}/libncursestw.so
%{gnuxc_libdir}/libncursesw.so
%{gnuxc_libdir}/libncurses++.so
%{gnuxc_libdir}/libncurses++t.so
%{gnuxc_libdir}/libncurses++tw.so
%{gnuxc_libdir}/libncurses++w.so
%{gnuxc_libdir}/libpanel.so
%{gnuxc_libdir}/libpanelt.so
%{gnuxc_libdir}/libpaneltw.so
%{gnuxc_libdir}/libpanelw.so
%{gnuxc_libdir}/libtic.so
%{gnuxc_libdir}/libtict.so
%{gnuxc_libdir}/libtictw.so
%{gnuxc_libdir}/libticw.so
%{gnuxc_libdir}/libtinfo.so
%{gnuxc_libdir}/libtinfot.so
%{gnuxc_libdir}/libtinfotw.so
%{gnuxc_libdir}/libtinfow.so
%{gnuxc_libdir}/pkgconfig/form.pc
%{gnuxc_libdir}/pkgconfig/formt.pc
%{gnuxc_libdir}/pkgconfig/formtw.pc
%{gnuxc_libdir}/pkgconfig/formw.pc
%{gnuxc_libdir}/pkgconfig/menu.pc
%{gnuxc_libdir}/pkgconfig/menut.pc
%{gnuxc_libdir}/pkgconfig/menutw.pc
%{gnuxc_libdir}/pkgconfig/menuw.pc
%{gnuxc_libdir}/pkgconfig/ncurses.pc
%{gnuxc_libdir}/pkgconfig/ncursest.pc
%{gnuxc_libdir}/pkgconfig/ncursestw.pc
%{gnuxc_libdir}/pkgconfig/ncursesw.pc
%{gnuxc_libdir}/pkgconfig/ncurses++.pc
%{gnuxc_libdir}/pkgconfig/ncurses++t.pc
%{gnuxc_libdir}/pkgconfig/ncurses++tw.pc
%{gnuxc_libdir}/pkgconfig/ncurses++w.pc
%{gnuxc_libdir}/pkgconfig/panel.pc
%{gnuxc_libdir}/pkgconfig/panelt.pc
%{gnuxc_libdir}/pkgconfig/paneltw.pc
%{gnuxc_libdir}/pkgconfig/panelw.pc
%{gnuxc_libdir}/pkgconfig/tic.pc
%{gnuxc_libdir}/pkgconfig/tict.pc
%{gnuxc_libdir}/pkgconfig/tictw.pc
%{gnuxc_libdir}/pkgconfig/ticw.pc
%{gnuxc_libdir}/pkgconfig/tinfo.pc
%{gnuxc_libdir}/pkgconfig/tinfot.pc
%{gnuxc_libdir}/pkgconfig/tinfotw.pc
%{gnuxc_libdir}/pkgconfig/tinfow.pc

%files static
%{gnuxc_libdir}/libcurses.a
%{gnuxc_libdir}/libform.a
%{gnuxc_libdir}/libform_g.a
%{gnuxc_libdir}/libformt.a
%{gnuxc_libdir}/libformt_g.a
%{gnuxc_libdir}/libformtw.a
%{gnuxc_libdir}/libformtw_g.a
%{gnuxc_libdir}/libformw.a
%{gnuxc_libdir}/libformw_g.a
%{gnuxc_libdir}/libmenu.a
%{gnuxc_libdir}/libmenu_g.a
%{gnuxc_libdir}/libmenut.a
%{gnuxc_libdir}/libmenut_g.a
%{gnuxc_libdir}/libmenutw.a
%{gnuxc_libdir}/libmenutw_g.a
%{gnuxc_libdir}/libmenuw.a
%{gnuxc_libdir}/libmenuw_g.a
%{gnuxc_libdir}/libncurses.a
%{gnuxc_libdir}/libncurses_g.a
%{gnuxc_libdir}/libncursest.a
%{gnuxc_libdir}/libncursest_g.a
%{gnuxc_libdir}/libncursestw.a
%{gnuxc_libdir}/libncursestw_g.a
%{gnuxc_libdir}/libncursesw.a
%{gnuxc_libdir}/libncursesw_g.a
%{gnuxc_libdir}/libncurses++.a
%{gnuxc_libdir}/libncurses++_g.a
%{gnuxc_libdir}/libncurses++t.a
%{gnuxc_libdir}/libncurses++t_g.a
%{gnuxc_libdir}/libncurses++tw.a
%{gnuxc_libdir}/libncurses++tw_g.a
%{gnuxc_libdir}/libncurses++w.a
%{gnuxc_libdir}/libncurses++w_g.a
%{gnuxc_libdir}/libpanel.a
%{gnuxc_libdir}/libpanel_g.a
%{gnuxc_libdir}/libpanelt.a
%{gnuxc_libdir}/libpanelt_g.a
%{gnuxc_libdir}/libpaneltw.a
%{gnuxc_libdir}/libpaneltw_g.a
%{gnuxc_libdir}/libpanelw.a
%{gnuxc_libdir}/libpanelw_g.a
%{gnuxc_libdir}/libtic.a
%{gnuxc_libdir}/libtic_g.a
%{gnuxc_libdir}/libtict.a
%{gnuxc_libdir}/libtict_g.a
%{gnuxc_libdir}/libtictw.a
%{gnuxc_libdir}/libtictw_g.a
%{gnuxc_libdir}/libticw.a
%{gnuxc_libdir}/libticw_g.a
%{gnuxc_libdir}/libtinfo.a
%{gnuxc_libdir}/libtinfo_g.a
%{gnuxc_libdir}/libtinfot.a
%{gnuxc_libdir}/libtinfot_g.a
%{gnuxc_libdir}/libtinfotw.a
%{gnuxc_libdir}/libtinfotw_g.a
%{gnuxc_libdir}/libtinfow.a
%{gnuxc_libdir}/libtinfow_g.a


%changelog
