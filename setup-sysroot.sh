#!/bin/bash

# This script builds and installs all the packages needed to cross-compile the
# complete operating system.  Packages are built in a manually defined sequence
# (see below), and retrying after build failures won't necessarily resume where
# the script exits.
#
# Please try setup-sysroot.scm for a better alternative to this script.  It can
# build the packages in parallel, and it resumes on any packages that failed.

set -ex
shopt -s expand_aliases nullglob

specdir=$(rpm -E %_specdir)
rpmdir=$(rpm -E %_rpmdir)

dnf_opts="--repofrompath='gnuxc-local,$rpmdir' --enablerepo='gnuxc-local' \
--setopt='gnuxc-local.name=gnuxc - Locally built cross-compiler packages' \
--setopt='gnuxc-local.include=gnuxc-*' \
--setopt='gnuxc-local.gpgcheck=0' \
--setopt='gnuxc-local.metadata_expire=0'"

# Delete these definitions when DNF works correctly (see above).
repo_conf="[gnuxc-local]
name=gnuxc - Locally built cross-compiler packages
baseurl=file://$rpmdir
include=gnuxc-*
gpgcheck=0
metadata_expire=0"
dnf_opts="--config=/dev/stdin --enablerepo='gnuxc-local' \
<<< \"\`cat /etc/dnf/dnf.conf ; echo '$repo_conf'\`\""

alias dnf-builddep="sudo dnf $dnf_opts -y builddep \
"'--define="_with$([ "$gnuxc_bootstrap" ] || echo out)_bootstrap 1"'
alias dnf-install="sudo dnf --disablerepo='*' $dnf_opts -y install"

function build_pkg() {
        local spec=$specdir/gnuxc-$1.spec
        local pkg=gnuxc-${2:-$1}
        rpm --quiet -q "$pkg" &&
                echo "Skipping $pkg (installed)" && return 0 || :
        dnf-builddep "$spec" ||
                echo "Failed to install dependencies of $pkg (ignoring)" 1>&2
        rpmbuild --clean --define='_disable_source_fetch 0' -ba "$spec" ||
                { echo "Failed to build the $pkg package" 1>&2 ; exit 2 ; }
        createrepo_c --no-database --simple-md-filenames "$rpmdir" ||
                { echo "Failed to refresh the repo for $pkg" 1>&2 ; exit 3 ; }
}

: << '#ENDMOCK' # Comment out this line to build everything with mock.
# This isn't quite ready.  In order to use it now, edit your mock configuration
# file to append gnuxc-filesystem to 'chroot_setup_cmd', and append the repo as
# defined in $dnf_opts to 'yum.conf'.  Also put actual copies of the patches in
# the RPM sources directory, not symlinks.  Then this script should work.
arch=$(rpm -E %_arch)
distro=fedora-$(rpm -E %fedora)-$arch
resultdir=/var/lib/mock/$distro/result
sourcedir=$(rpm -E %_sourcedir)
alias run_mock="sudo mock --root=$distro --dnf \
--define='_disable_source_fetch 0' \
"'--with$([ "$gnuxc_bootstrap" ] || echo out)=bootstrap'
function init_mock_repo() {
        # Stupidly provide a non-mock filesystem RPM for 'chroot_setup_cmd'.
        rpmbuild --clean -bb "$specdir/gnuxc-filesystem.spec"
        mv "$rpmdir/noarch"/gnuxc-filesystem-*.noarch.rpm "$rpmdir/"
        rmdir "$rpmdir/noarch" 2>/dev/null || : # Clean up.
        createrepo_c --no-database --simple-md-filenames "$rpmdir"
}
function build_pkg() {
        local spec=$specdir/gnuxc-$1.spec
        local pkg=gnuxc-${2:-$1}
        for x in "$rpmdir/$pkg"-[0-9]*.{$arch,noarch}.rpm ; do ! ; done ||
                { echo "Skipping $pkg (already exists)" ; return 0 ; }
        [ "$1" != filesystem ] || init_mock_repo
        run_mock --buildsrpm --sources "$sourcedir" --spec "$spec" ||
                { echo "Failed to make a $pkg source package" 1>&2 ; exit 2 ; }
        run_mock --rebuild /dev/stdin < "$resultdir"/*.src.rpm ||
                { echo "Failed to build the $pkg package" 1>&2 ; exit 3 ; }
        cp -p "$resultdir"/*.rpm "$rpmdir/" ||
                { echo "Could not save the $pkg RPMs" 1>&2 ; exit 4 ; }
        createrepo_c --no-database --simple-md-filenames "$rpmdir" ||
                { echo "Failed to refresh the repo for $pkg" 1>&2 ; exit 5 ; }
}
#ENDMOCK

# Build every RPM using this example dependency chain.
gnuxc_bootstrap=1
build_pkg filesystem
build_pkg pkg-config
build_pkg binutils
build_pkg gcc
build_pkg gnumach       gnumach-headers
build_pkg mig
build_pkg hurd          hurd-headers
build_pkg glibc
unset gnuxc_bootstrap
build_pkg gcc           gcc-c++
build_pkg ncurses
build_pkg readline
build_pkg expat
build_pkg zlib
build_pkg bzip2
build_pkg hurd          hurd-libs
build_pkg e2fsprogs     libuuid
build_pkg parted
build_pkg binutils      binutils-libs
build_pkg tcl
build_pkg file
build_pkg attr
build_pkg acl
build_pkg xz
build_pkg pcre
build_pkg gmp
build_pkg mpfr
build_pkg mpc
build_pkg libffi
build_pkg libatomic_ops
build_pkg gc
build_pkg libunistring
build_pkg libtool       ltdl
build_pkg guile
build_pkg glib
build_pkg liboop
build_pkg libidn
build_pkg libtasn1
build_pkg nettle
build_pkg p11-kit
build_pkg gnutls
build_pkg libgpg-error
build_pkg libgcrypt
build_pkg osl
build_pkg isl
build_pkg cloog
build_pkg libpng
build_pkg freetype
build_pkg flex
build_pkg gdbm
build_pkg icu4c
build_pkg libpipeline
build_pkg sqlite
build_pkg python
build_pkg libxml2
build_pkg libcroco
build_pkg gettext
# (xorg
build_pkg font-util
build_pkg fontconfig
build_pkg libpciaccess
build_pkg pixman
build_pkg xproto        ; build_pkg libXau           ; build_pkg libXdmcp
build_pkg xtrans        ; build_pkg libICE           ; build_pkg libSM
build_pkg xextproto
build_pkg xcb-proto     ; build_pkg libpthread-stubs
build_pkg libxcb        ; build_pkg xcb-util-keysyms
build_pkg kbproto       ; build_pkg inputproto       ; build_pkg libX11
build_pkg libxkbfile
build_pkg libXext       ; build_pkg libXt
build_pkg libXmu        ; build_pkg libXpm           ; build_pkg libXaw
build_pkg fontsproto    ; build_pkg libfontenc       ; build_pkg libXfont
build_pkg renderproto   ; build_pkg libXrender       ; build_pkg libXft
build_pkg fixesproto    ; build_pkg libXfixes        ; build_pkg libXi
build_pkg damageproto   ; build_pkg libXdamage
build_pkg randrproto    ; build_pkg libXrandr
build_pkg xineramaproto ; build_pkg libXinerama
build_pkg glproto       ; build_pkg mesa
build_pkg bigreqsproto  ; build_pkg presentproto     ; build_pkg resourceproto
build_pkg videoproto    ; build_pkg xcmiscproto      ; build_pkg xf86dgaproto
build_pkg xorg-server
build_pkg spice-protocol
# xorg)
build_pkg tk
build_pkg cairo
build_pkg harfbuzz
build_pkg pango
build_pkg libjpeg-turbo
build_pkg jasper
build_pkg giflib
build_pkg jbigkit
build_pkg tiff
build_pkg gdk-pixbuf
build_pkg librsvg
# (mozilla
build_pkg libepoxy
build_pkg atk
build_pkg gtk+
build_pkg libevent
build_pkg libvpx
build_pkg nspr
build_pkg nss
# mozilla)
build_pkg gtk2 # old, compat

# Install any remaining compilers and development packages.
dnf-install \
    'gnuxc-*-devel' 'gnuxc-*proto' gnuxc-{libpthread-stubs,spice-protocol} \
    gnuxc-gcc-{gfortran,objc++} gnuxc-mig gnuxc-pkg-config \
    gnuxc-{bzip2,glibc,libuuid,parted,zlib}-static
