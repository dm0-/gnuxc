#!/bin/bash

set -e

specdir=$(rpm -E %_specdir)
rpmdir=$(rpm -E %_rpmdir)
repo=rpmbuild

function build_pkg() {
        local spec=$specdir/gnuxc-$1.spec
        local pkg=gnuxc-${2:-$1}
        rpm --quiet -q "$pkg" &&
                echo "Skipping $pkg (installed)" && return 0 || :
        sudo yum-builddep --enablerepo=$repo -y "$spec" ||
                ( echo "Failed to install dependencies of $pkg" 1>&2 ; exit 1 )
        spectool -g -R "$spec" ||
                ( echo "Failed to fetch source files for $pkg" 1>&2 ; exit 2 )
        rpmbuild --clean -ba "$spec" ||
                ( echo "Failed to build the $pkg package" 1>&2 ; exit 3 )
        createrepo "$rpmdir" &&
        sudo yum --disablerepo=* --enablerepo=$repo clean all ||
                ( echo "Failed to refresh the repo for $pkg" 1>&2 ; exit 4 )
}

function install_pkg() {
        local pkg=gnuxc-$1
        rpm --quiet -q "$pkg" ||
        sudo yum --disablerepo=* --enablerepo=$repo -y install "$pkg"
}

# Build every RPM using this example dependency chain.
build_pkg filesystem
build_pkg pkg-config                       ; install_pkg pkg-config
build_pkg binutils
build_pkg gcc
build_pkg gnumach       gnumach-headers
build_pkg mig
build_pkg hurd          hurd-headers
build_pkg glibc                            ; install_pkg glibc
build_pkg gcc           gcc-c++
build_pkg ncurses
build_pkg readline
build_pkg zlib
build_pkg bzip2
build_pkg hurd          hurd-libs
build_pkg e2fsprogs     libuuid
build_pkg parted
build_pkg binutils      binutils-libs
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
build_pkg gnutls
build_pkg libgpg-error
build_pkg libgcrypt
build_pkg osl
build_pkg piplib
build_pkg isl
build_pkg cloog
build_pkg libxml2
build_pkg libcroco
build_pkg gettext
build_pkg libpng
build_pkg freetype
build_pkg flex
build_pkg gdbm
build_pkg libpipeline
build_pkg sqlite
# (xorg
build_pkg font-util
build_pkg fontconfig
build_pkg libpciaccess
build_pkg pixman
build_pkg xproto       ; build_pkg libXau           ; build_pkg libXdmcp
build_pkg xtrans       ; build_pkg libICE           ; build_pkg libSM
build_pkg xextproto
build_pkg xcb-proto    ; build_pkg libpthread-stubs ; build_pkg libxcb
build_pkg kbproto      ; build_pkg inputproto       ; build_pkg libX11
build_pkg libxkbfile
build_pkg libXext      ; build_pkg libXt
build_pkg libXmu       ; build_pkg libXpm           ; build_pkg libXaw
build_pkg fontsproto   ; build_pkg libfontenc       ; build_pkg libXfont
build_pkg renderproto  ; build_pkg libXrender       ; build_pkg libXft
build_pkg bigreqsproto ; build_pkg damageproto      ; build_pkg fixesproto
build_pkg presentproto ; build_pkg randrproto       ; build_pkg videoproto
build_pkg xcmiscproto  ; build_pkg xf86dgaproto
build_pkg xorg-server
build_pkg spice-protocol
# xorg)
build_pkg cairo
build_pkg harfbuzz
build_pkg pango
build_pkg libjpeg-turbo
build_pkg gdk-pixbuf
build_pkg librsvg

# Install any remaining compilers and development packages.
sudo yum --disablerepo=* --enablerepo=$repo -y install \
    gnuxc-gcc-{gfortran,objc++} \
    gnuxc-*-devel gnuxc-spice-protocol \
    gnuxc-{bzip2,glibc,libihash,libpthread,libuuid,parted,zlib}-static
