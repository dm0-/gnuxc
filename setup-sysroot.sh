#!/bin/bash
set -e
shopt -s expand_aliases

specdir=$(rpm -E %_specdir)
rpmdir=$(rpm -E %_rpmdir)

repo_name=rpmbuild
repo_opts="--config=/dev/stdin --enablerepo='$repo_name' \
<<< \"\`cat /etc/yum.conf ; echo '[$repo_name]' ; \
echo name='Local Custom Packages' ; echo baseurl='file://$rpmdir' ; \
echo gpgcheck=0 ; echo metadata_expire=0\`\""

alias yum-builddep="\
sudo gnuxc_bootstrapped=\$gnuxc_bootstrapped yum-builddep $repo_opts -y"
alias yum-install="sudo yum --disablerepo='*' $repo_opts -y install"

function build_pkg() {
        local spec=$specdir/gnuxc-$1.spec
        local pkg=gnuxc-${2:-$1}
        rpm --quiet -q "$pkg" &&
                echo "Skipping $pkg (installed)" && return 0 || :
        yum-builddep "$spec" ||
                ( echo "Failed to install dependencies of $pkg" 1>&2 ; exit 1 )
        rpmbuild --clean --define='_disable_source_fetch 0' -ba "$spec" ||
                ( echo "Failed to build the $pkg package" 1>&2 ; exit 2 )
        createrepo --no-database --simple-md-filenames "$rpmdir" ||
                ( echo "Failed to refresh the repo for $pkg" 1>&2 ; exit 3 )
}

# Build every RPM using this example dependency chain.
export gnuxc_bootstrapped=0
build_pkg filesystem
build_pkg pkg-config
build_pkg binutils
build_pkg gcc
build_pkg gnumach       gnumach-headers
build_pkg mig
build_pkg hurd          hurd-headers
build_pkg glibc
export gnuxc_bootstrapped=1
build_pkg gcc           gcc-c++
build_pkg ncurses
build_pkg readline
build_pkg zlib
build_pkg bzip2
build_pkg hurd          hurd-libs
build_pkg e2fsprogs     libuuid
build_pkg parted
build_pkg binutils      binutils-libs
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
build_pkg xcb-proto     ; build_pkg libpthread-stubs ; build_pkg libxcb
build_pkg kbproto       ; build_pkg inputproto       ; build_pkg libX11
build_pkg libxkbfile
build_pkg libXext       ; build_pkg libXt
build_pkg libXmu        ; build_pkg libXpm           ; build_pkg libXaw
build_pkg fontsproto    ; build_pkg libfontenc       ; build_pkg libXfont
build_pkg renderproto   ; build_pkg libXrender       ; build_pkg libXft
build_pkg fixesproto    ; build_pkg libXfixes        ; build_pkg libXi
build_pkg randrproto    ; build_pkg libXrandr
build_pkg xineramaproto ; build_pkg libXinerama
build_pkg bigreqsproto  ; build_pkg damageproto      ; build_pkg presentproto
build_pkg resourceproto ; build_pkg videoproto       ; build_pkg xcmiscproto
build_pkg xf86dgaproto
build_pkg xorg-server
build_pkg spice-protocol
# xorg)
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
build_pkg atk
build_pkg gtk2
build_pkg libevent
build_pkg libvpx
build_pkg nspr
build_pkg nss
# mozilla)

# Install any remaining compilers and development packages.
yum-install \
    'gnuxc-*-devel' 'gnuxc-*proto' gnuxc-{libpthread-stubs,spice-protocol} \
    gnuxc-gcc-{gfortran,objc++} gnuxc-mig gnuxc-pkg-config \
    gnuxc-{bzip2,glibc,libuuid,parted,zlib}-static
